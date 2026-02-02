extends Control
class_name Problem_UI

var letter_ui_scene: PackedScene = preload("res://Game_Mechanics/Word_Problem/Problem_UI/letter_ui/letter_ui.tscn")
var divider_ui_scene: PackedScene = preload("res://Game_Mechanics/Word_Problem/Problem_UI/divider_ui/divider_ui.tscn")

@onready var question_location: Control = $PanelContainer/CenterContainer/HBoxContainer

var current_word: Word

func set_question(new_problem: Problem):
	current_word = new_problem.word
	
	# first, remove the current question form ui
	if is_node_ready():
		return
	for bastard in question_location.get_children():
		bastard.queue_free()
	
	for i in range(current_word.syallbles.size()):
		var index_name = 0
		var syallble: String = current_word.syallbles[i]
		for letter in syallble:
			var new_letter: Letter_UI = letter_ui_scene.instantiate()
			new_letter.set_letter(letter)
			new_letter.name = str(index_name)
			index_name += 1
			question_location.add_child(new_letter)
		if i != current_word.syallbles.size():
			var new_divider = divider_ui_scene.instantiate()
			question_location.add_child(new_divider)

func set_letter_correct(index: int, is_correct: bool = true):
	var letter: Letter_UI
	var name_to_find: String = str(index)
	for child in question_location.get_childern():
		if child.name == name_to_find:
			letter = child
	if letter:
		letter.set_correct(is_correct)
	else:
		print("Error in set_letter_correct: Didn't find letter at ", index)
