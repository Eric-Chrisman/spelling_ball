# database_manager.gd
extends Node

const GAME_DB_PATH = "res://Database_Words/Database/Words.db"
const USER_DB_PATH = "user://word.db"

var db: SQLite

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
	"""Open the database connection"""
	db = SQLite.new()
	db.path = USER_DB_PATH
	db.open_db()
	
	if db:
		print("Database connection opened successfully")
	else:
		push_error("Failed to open database connection")

func get_writable_db_path() -> String:
	return USER_DB_PATH

func generate_word() -> Word:
	"""Query a random word from the database and return a Word object"""
	if not db:
		push_error("Database not initialized!")
		return null
	
	# Query a random word from the Word table
	var query = "SELECT * FROM Word WHERE is_real = 1 ORDER BY RANDOM() LIMIT 1;"
	db.query(query)
	
	if db.query_result.size() > 0:
		var word_data = db.query_result[0]
		var word_name = word_data["name"]
		
		# Query syllables for this word via Syllable_Index
		var syllable_query = """
			SELECT s.syllable, s.syllable_type, si.position
			FROM Syllable_Index si
			JOIN Syllable s ON si.syllable_id = s.syllable_id
			WHERE si.word_id = '%s'
			ORDER BY si.position;
		""" % word_name
		
		db.query(syllable_query)
		
		# Build syllables array
		var syllables: Array[Syllable] = []
		for syllable_data in db.query_result:
			# Use OPEN as placeholder for now (first enum value)
			var syllable = Syllable.new(
				syllable_data["syllable"],
				Syllable.SYLLABLE_TYPE.OPEN  # Placeholder
			)
			syllables.append(syllable)
		
		# Create and return the Word object
		var new_word = Word.new(word_name, syllables)
		print("Generated word: ", new_word.text, " (", syllables.size(), " syllables)")
		return new_word
	else:
		push_error("No words found in database!")
		return null

func _exit_tree():
	"""Clean up database connection on exit"""
	if db:
		db.close_db()
		print("Database connection closed")
