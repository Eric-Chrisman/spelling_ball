extends Node

func _ready():
	open_import_dialog()

func open_import_dialog():
	DisplayServer.file_dialog_show(
		"Select a File",
		"",
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
		[],
		_on_file_selected
	)

func _on_file_selected(status: bool, paths: PackedStringArray, filter_index: int):
	if not status or paths.is_empty():
		print("No file selected.")
		return
	
	var path = paths[0]
	print("File path: ", path)
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Failed to open file. Error: ", FileAccess.get_open_error())
		return
	
	var content = file.get_as_text()
	file.close()
	
	print("--- File Contents ---")
	print(content)
	print("--- End ---")
