extends Control

@export var name_input: TextEdit
@export var status_label: Label
var valid_regex := RegEx.new()

signal menu_closed

func _ready():
	status_label.text = "Please enter a name."
	valid_regex.compile("[^A-Za-z0-9_]")

func _on_create_pressed():
	var set_name = name_input.text.strip_edges()
	if set_name.is_empty():
		status_label.text = "Please enter a name."
		return
	var success = DbManager.create_problem_set(set_name)
	if success:
		status_label.text = "Problem set created!"
		name_input.clear()
	else:
		status_label.text = "Set already exists or DB error."

func _on_text_edit_text_changed() -> void:
	var current_text = name_input.text
	var cleaned = valid_regex.sub(current_text, "", true)
	if cleaned != current_text:
		var caret = name_input.get_caret_column()
		name_input.text = cleaned
		name_input.set_caret_column(max(0, caret - 1))

func _on_button_pressed() -> void:
	visible = false
	status_label.text = "Please enter a name"
	name_input.text = ""
	emit_signal("menu_closed")
