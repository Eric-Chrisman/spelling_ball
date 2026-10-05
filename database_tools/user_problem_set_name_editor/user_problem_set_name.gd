extends Control

@export var name_input: LineEdit
@export var status_label: Label

var valid_regex: RegEx = RegEx.new()

signal menu_closed
signal set_created(set_name: String)

func _ready() -> void:
	status_label.text = "Please enter a name."
	valid_regex.compile("[^A-Za-z0-9_]")

func _on_create_pressed() -> void:
	var set_name = name_input.text.strip_edges()
	
	if set_name.is_empty():
		status_label.text = "Can't be empty!"
		return
	
	var success = DbManager.create_problem_set(set_name)
	
	if success:
		status_label.text = "Problem set created!"
		name_input.clear()
		_on_button_pressed()
		set_created.emit(set_name)
	else:
		status_label.text = "Set already exists or DB error."

func _on_name_input_text_changed(new_text: String) -> void:
	var cleaned = valid_regex.sub(new_text, "", true)
	
	if cleaned != new_text:
		name_input.text = cleaned
		name_input.caret_column = cleaned.length()

func _on_name_input_text_submitted(_new_text: String) -> void:
	_on_create_pressed()

func _on_button_pressed() -> void:
	visible = false
	status_label.text = "Please enter a name."
	name_input.clear()
	menu_closed.emit()
