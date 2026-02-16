extends Control
class_name Problem_UI

var letter_ui_scene: PackedScene = preload("res://Game_Mechanics/Problem/Problem_UI/letter_ui/letter_ui.tscn")
var divider_ui_scene: PackedScene = preload("res://Game_Mechanics/Problem/Problem_UI/divider_ui/divider_ui.tscn")

@onready var question_location: HBoxContainer = $PanelContainer/CenterContainer/HBoxContainer

var current_word: Word

func set_question(new_word: Word):
	current_word = new_word
	
	# First, remove the current question from ui
	if not is_node_ready():
		await ready
	
	for child in question_location.get_children():
		question_location.remove_child(child)
		child.queue_free()
	
	var letter_index = 0
	
	for i in range(current_word.syllables.size()):
		var syllable: Syllable = current_word.syllables[i]
		
		for letter in syllable.text:
			var new_letter: Letter_UI = letter_ui_scene.instantiate()
			new_letter.set_letter(letter)
			new_letter.name = str(letter_index)
			letter_index += 1
			question_location.add_child(new_letter)
		
		# Add divider after syllable (but not after the last one)
		if i != current_word.syllables.size() - 1:
			var new_divider = divider_ui_scene.instantiate()
			question_location.add_child(new_divider)

func set_letter_correct(index: int, is_correct: bool = true):
	var letter: Letter_UI = null
	var name_to_find: String = str(index)
	
	for child in question_location.get_children():
		if child.name == name_to_find:
			letter = child
			break
	
	if letter:
		letter.set_correct(is_correct)
	else:
		push_error("Error in set_letter_correct: Didn't find letter at index " + str(index))
