# database_manager.gd
extends Node

const GAME_DB_PATH = "res://Database_Words/Database/Words.db"
const USER_DB_PATH = "user://Word.db"
var db: SQLite

# Game settings (set by UI, used by generate_word)
var fake_word_probability: float = 0.5
var min_word_length: int = 1
var max_word_length: int = 10
var min_syllables: int = 1
var max_syllables: int = 4
var allowed_syllable_types: Array[String] = ["Open", "Closed", "Magic_e", "R_controlled", "Vowel Team", "Consonant-le", "Diphthong"]

var word_pool: Array = []

func _ready():
	initialize_database()
	open_database()

func initialize_database() -> void:
	if not FileAccess.file_exists(USER_DB_PATH):
		print("User database not found. Copying from game files...")
		copy_database()
	else:
		print("User database found at: ", USER_DB_PATH)
	print("Using database: ", USER_DB_PATH)

func copy_database() -> void:
	var source_file = FileAccess.open(GAME_DB_PATH, FileAccess.READ)
	if source_file == null:
		push_error("Failed to open source database: " + GAME_DB_PATH)
		return
	var file_data = source_file.get_buffer(source_file.get_length())
	source_file.close()
	var dest_file = FileAccess.open(USER_DB_PATH, FileAccess.WRITE)
	if dest_file == null:
		push_error("Failed to create user database at: " + USER_DB_PATH)
		return
	dest_file.store_buffer(file_data)
	dest_file.close()
	print("Database successfully copied to: ", USER_DB_PATH)

func open_database() -> void:
	db = SQLite.new()
	db.path = USER_DB_PATH
	db.open_db()
	if db:
		print("Database connection opened successfully")
		refresh_word_pool()
	else:
		push_error("Failed to open database connection")

func get_writable_db_path() -> String:
	return USER_DB_PATH

# Call this once on boot and whenever settings change
# Will lag!
func refresh_word_pool() -> void:
	if not db:
		push_error("Database not initialized!")
		return

	var type_list = []
	for t in allowed_syllable_types:
		type_list.append("'%s'" % t)
	var type_filter = ", ".join(type_list)

	var query = """
		SELECT w.name, w.is_real
		FROM Words w
		WHERE w.letter_count BETWEEN %d AND %d
		AND w.syllable_count BETWEEN %d AND %d
		AND EXISTS (
			SELECT 1
			FROM Syllable_Indexes si
			JOIN Syllables s ON s.syllable_id = si.syllable_id
			WHERE si.word_id = w.name
			AND s.syllable_type IN (%s)
		);
	""" % [min_word_length, max_word_length, min_syllables, max_syllables, type_filter]

	db.query(query)
	word_pool = db.query_result.duplicate()
	print("Word pool refreshed: %d words available" % word_pool.size())
	print(word_pool.slice(0,3), " ... ", word_pool.slice(-3, -1))

func generate_word() -> Word:
	if word_pool.is_empty():
		push_error("Word pool is empty! Check settings and call refresh_word_pool().")
		return null

	var real_words = word_pool.filter(func(w): return w["is_real"] == 1)
	var fake_words = word_pool.filter(func(w): return w["is_real"] == 0)

	var candidates = real_words if randf() >= fake_word_probability else fake_words
	if candidates.is_empty():
		candidates = word_pool
	var word_data = candidates[randi() % candidates.size()]
	var word_name = word_data["name"]

	var syllable_query = """
		SELECT s.syllable, s.syllable_type, si.position
		FROM Syllable_Indexes si
		JOIN Syllables s ON si.syllable_id = s.syllable_id
		WHERE si.word_id = '%s'
		ORDER BY si.position;
	""" % word_name

	db.query(syllable_query)

	var syllables: Array[Syllable] = []
	for syllable_data in db.query_result:
		var syllable = Syllable.new(
			syllable_data["syllable"],
			Syllable.get_syllable_type_from_string(syllable_data["syllable_type"])
		)
		syllables.append(syllable)

	var new_word = Word.new(word_name, syllables, word_data["is_real"])
	print("Generated word: ", new_word.text, " (", syllables.size(), " syllables)")
	return new_word

func _exit_tree():
	if db:
		db.close_db()
		print("Database connection closed")
