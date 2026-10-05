extends HBoxContainer
class_name word_container

signal edit_button
signal delete_button

func set_text(new_text: String):
	$Label.text = new_text

func _on_delete_button() -> void:
	emit_signal("delete_button")
