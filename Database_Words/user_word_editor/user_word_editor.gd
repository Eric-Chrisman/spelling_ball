extends Control
class_name user_word_editor

var preloaded_letter_ui: PackedScene = preload("res://Game_Mechanics/Problem/Problem_UI/letter_ui/letter_ui.tscn")
var preloaded_divider_ui: PackedScene = preload("res://Game_Mechanics/Problem/Problem_UI/divider_ui/divider_ui.tscn")

@export var where_to_add_sample_text_labels: Control
@export var text_input: TextEdit
@export var add_button: Button

signal cancel
signal add_word(new_word: Word)

func reset_sample_labels() -> void:
	for child in where_to_add_sample_text_labels.get_children():
		child.queue_free()

	var syllable: String = ""
	for letter in text_input.text:
		if letter == ";" and syllable != "":
			var color = SyllableColorConst.get_color_from_syllable_type(Syllable.classify(syllable))
			for s_letter in syllable:
				var letter_ui: Letter_UI = preloaded_letter_ui.instantiate()
				where_to_add_sample_text_labels.add_child(letter_ui)
				letter_ui.set_letter(s_letter, color, false)
			syllable = ""
		if letter == ";":
			where_to_add_sample_text_labels.add_child(preloaded_divider_ui.instantiate())
		else:
			syllable += letter
	
	if syllable != "":
		var color = SyllableColorConst.get_color_from_syllable_type(Syllable.classify(syllable))
		for s_letter in syllable:
			var letter_ui: Letter_UI = preloaded_letter_ui.instantiate()
			where_to_add_sample_text_labels.add_child(letter_ui)
			letter_ui.set_letter(s_letter, color, false)
	
	add_button.disabled = !is_word_valid()

func is_word_valid() -> bool:
	var t = text_input.text
	if t.is_empty():
		return false
	if t.begins_with(";") or t.ends_with(";"):
		return false
	if ";;" in t:
		return false
	for c in t:
		if c != ";":
			return true
	return false

func _on_button_pressed() -> void:
	text_input.text = ""
	reset_sample_labels()
	visible = false

func _on_button_2_pressed() -> void:
	var syllables: Array[Syllable] = []
	var full_text: String = ""
	for part in text_input.text.split(";"):
		if part != "":
			syllables.append(Syllable.new(part, Syllable.classify(part)))
			full_text += part
	var new_word = Word.new(full_text, syllables, true)
	new_word.print_word()
	emit_signal("add_word", new_word)
	_on_button_pressed()
