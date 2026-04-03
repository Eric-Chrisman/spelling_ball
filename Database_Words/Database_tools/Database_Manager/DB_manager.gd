extends Node

const GAME_DB_PATH = "res://Database_Words/Database/Words.db"
const USER_DB_PATH = "user://Words.db"

var db: SQLite

# Game settings
var fake_word_probability: float = 0.5
var min_word_length: int = 1
var max_word_length: int = 10
var min_syllables: int = 1
var max_syllables: int = 4

var selected_problem_set: String = ""

# FIX: strings now match get_syllable_type_from_string() and get_string_from_syllable_type()
#      (hyphens not underscores, correct capitalisation)
var allowed_syllable_types: Array[String] = [
	"Open",
	"Closed",
	"Magic-e",
	"R-controlled",
	"Vowel Team",
	"Consonant-le",
	"Diphthong"
]

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
		push_error("Failed to open source database")
		return

	var file_data = source_file.get_buffer(source_file.get_length())
	source_file.close()

	var dest_file = FileAccess.open(USER_DB_PATH, FileAccess.WRITE)

	if dest_file == null:
		push_error("Failed to create user database")
		return

	dest_file.store_buffer(file_data)
	dest_file.close()

	print("Database successfully copied.")


func open_database() -> void:
	db = SQLite.new()
	db.path = USER_DB_PATH
	db.open_db()

	if db:
		print("Database connection opened")
		refresh_word_pool()
	else:
		push_error("Database failed to open")


func get_writable_db_path() -> String:
	return USER_DB_PATH


# =========================
# WORD POOL GENERATION
# =========================

func refresh_word_pool() -> void:

	if not db:
		push_error("Database not initialized")
		return

	var type_list = []

	for t in allowed_syllable_types:
		type_list.append("'%s'" % t)

	var type_filter = ", ".join(type_list)

	var query = """
	WITH valid_word_ids AS (
		SELECT DISTINCT si.word_id
		FROM Syllable_Indexes si
		JOIN Syllables s ON s.syllable_id = si.syllable_id
		WHERE s.syllable_type IN (%s)
	)
	SELECT w.word_id, w.name, w.is_real
	FROM Words w
	JOIN valid_word_ids v ON v.word_id = w.word_id
	WHERE w.letter_count BETWEEN %d AND %d
	AND w.syllable_count BETWEEN %d AND %d;
	""" % [
		type_filter,
		min_word_length,
		max_word_length,
		min_syllables,
		max_syllables
	]

	db.query(query)

	word_pool = db.query_result.duplicate()

	print("Word pool refreshed:", word_pool.size())

func generate_word() -> Word:

	# If a problem set is selected, pull randomly from it instead of the word pool
	if selected_problem_set != "":
		var ps_words = get_all_words_from_problem_set(selected_problem_set)
		if ps_words.is_empty():
			push_error("Problem set is empty: " + selected_problem_set)
			return null
		return ps_words[randi() % ps_words.size()]

	if word_pool.is_empty():
		push_error("Word pool empty")
		return null

	var real_words = word_pool.filter(func(w): return w["is_real"] == 1)
	var fake_words = word_pool.filter(func(w): return w["is_real"] == 0)

	var candidates = real_words if randf() >= fake_word_probability else fake_words

	if candidates.is_empty():
		candidates = word_pool

	var word_data = candidates[randi() % candidates.size()]

	return get_word_by_id(word_data["word_id"])


func get_word_by_id(word_id: int) -> Word:

	var query = """
	SELECT name, is_real
	FROM Words
	WHERE word_id = %d;
	""" % word_id

	db.query(query)

	if db.query_result.size() == 0:
		return null

	var data = db.query_result[0]

	var syllable_query = """
	SELECT s.syllable, s.syllable_type, si.position
	FROM Syllable_Indexes si
	JOIN Syllables s ON si.syllable_id = s.syllable_id
	WHERE si.word_id = %d
	ORDER BY si.position;
	""" % word_id

	db.query(syllable_query)

	var syllables: Array[Syllable] = []

	for row in db.query_result:
		syllables.append(
			Syllable.new(
				row["syllable"],
				Syllable.get_syllable_type_from_string(row["syllable_type"])
			)
		)

	return Word.new(data["name"], syllables, data["is_real"])


# =========================
# PROBLEM SETS
# =========================

func get_all_problem_sets() -> Array[String]:

	db.query("SELECT name FROM Problem_Sets ORDER BY name;")

	var result: Array[String] = []

	for row in db.query_result:
		result.append(row["name"])

	return result


func create_problem_set(set_name: String) -> bool:

	var query = """
	INSERT INTO Problem_Sets (name)
	VALUES ('%s');
	""" % set_name.replace("'", "''")

	var success = db.query(query)

	return success


func get_all_words_from_problem_set(problem_set: String) -> Array[Word]:

	var query = """
	SELECT w.word_id
	FROM Words w
	JOIN Problem_Set_Words psw ON w.word_id = psw.word_id
	JOIN Problem_Sets ps ON ps.set_id = psw.set_id
	WHERE ps.name = '%s'
	ORDER BY w.name;
	""" % problem_set.replace("'", "''")

	db.query(query)

	var words: Array[Word] = []

	for row in db.query_result:
		words.append(get_word_by_id(row["word_id"]))

	return words


func add_word_to_problem_set(word: Word, problem_set: String):

	var word_id = ensure_word_exists(word)

	var set_query = "SELECT set_id FROM Problem_Sets WHERE name = '%s';" % problem_set.replace("'", "''")
	db.query(set_query)

	if db.query_result.is_empty():
		push_error("Problem set not found")
		return

	var set_id = db.query_result[0]["set_id"]

	var query = """
	INSERT OR IGNORE INTO Problem_Set_Words (set_id, word_id)
	VALUES (%d, %d);
	""" % [set_id, word_id]

	db.query(query)


func remove_word_from_problem_set(word: Word, problem_set: String):

	var word_query = "SELECT word_id FROM Words WHERE name='%s';" % word.text.replace("'", "''")
	db.query(word_query)

	if db.query_result.is_empty():
		return

	var word_id = db.query_result[0]["word_id"]

	var set_query = "SELECT set_id FROM Problem_Sets WHERE name='%s';" % problem_set.replace("'", "''")
	db.query(set_query)

	if db.query_result.is_empty():
		return

	var set_id = db.query_result[0]["set_id"]

	var delete_query = """
	DELETE FROM Problem_Set_Words
	WHERE set_id=%d AND word_id=%d;
	""" % [set_id, word_id]

	db.query(delete_query)


# =========================
# WORD INSERT / UPDATE
# =========================

func ensure_word_exists(word: Word) -> int:

	var query = "SELECT word_id FROM Words WHERE name='%s';" % word.text.replace("'", "''")
	db.query(query)

	var word_id: int

	if db.query_result.is_empty():

		var insert_query = """
		INSERT INTO Words (name, syllable_count, letter_count, is_real)
		VALUES ('%s', %d, %d, %d);
		""" % [
			word.text.replace("'", "''"),
			word.get_syllable_count(),
			word.get_letter_count(),
			int(word.is_real)  # FIX: cast bool to int
		]

		db.query(insert_query)
		db.query(query)

		if db.query_result.is_empty():  # FIX: guard against failed INSERT
			push_error("INSERT failed for word: " + word.text)
			return -1

		word_id = db.query_result[0]["word_id"]

	else:
		word_id = db.query_result[0]["word_id"]
		db.query("DELETE FROM Syllable_Indexes WHERE word_id=%d;" % word_id)

	insert_syllables(word_id, word)
	return word_id


func insert_syllables(word_id: int, word: Word):

	for i in range(word.syllables.size()):
		var s = word.syllables[i]

		var insert_syl = """
		INSERT OR IGNORE INTO Syllables (syllable, syllable_type)
		VALUES ('%s', '%s');
		""" % [
			s.text.replace("'", "''"),
			Syllable.get_string_from_syllable_type(s.Syllable_Type)  # FIX: was get_syllable_type_from_string(s.type)
		]
		db.query(insert_syl)

		var get_id = "SELECT syllable_id FROM Syllables WHERE syllable='%s';" % s.text.replace("'", "''")
		db.query(get_id)

		var syll_id = db.query_result[0]["syllable_id"]

		var link = """
		INSERT INTO Syllable_Indexes (syllable_id, word_id, position)
		VALUES (%d, %d, %d);
		""" % [syll_id, word_id, i]
		db.query(link)


func _exit_tree():
	if db:
		db.close_db()
