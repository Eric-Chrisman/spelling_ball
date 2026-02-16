extends Node

const GAME_DB_PATH = "res://Database_Words/Database/Words.db"
const USER_DB_PATH = "user://word.db"

func _ready():
	initialize_database()

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

func get_writable_db_path() -> String:
	return USER_DB_PATH
