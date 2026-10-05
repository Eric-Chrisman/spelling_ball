extends Node
class_name Problem_Tracker

# Tracks the problem currently in play. Also controls tts

@export var UI: Problem_UI
@export var tts: TTS

var current_word: Word
var progress: int = 0

signal correct_letter_hit(letter_in_sequence: float)
signal wrong_letter_hit
signal problem_solved

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space") and current_word:
		tts.play(current_word.text)

func letter_hit(letter: String):
	#print(letter)
	# correct
	if current_word.text[progress] == letter:
		progress += 1
		UI.set_letter_correct(progress - 1, true)
		emit_signal("correct_letter_hit", float(progress) / current_word.text.length())
		
		# problem solved
		if progress == current_word.text.length():
			emit_signal("problem_solved")
			$completed_problem_wait_time.start()
			#generate_word()
			# update ui
	# wrong
	else:
		emit_signal("wrong_letter_hit")
		pass # i don't know yet, come back here later

# function gives you the next character that spells the word
func get_next_letter(offset: int) -> String:
	return current_word.text[progress]

func generate_answer_choices(number_of_choices: int = 3) -> Array[String]:
	var choices: Array[String] = []
	choices.append(current_word.text[progress].to_lower())
	number_of_choices -= 1
	if progress != current_word.text.length() - 1:
		choices.append(current_word.text[progress + 1].to_lower())
		number_of_choices -= 1
	
	# Define possible letters to choose from (excluding the correct one)
	var alphabet: String = "abcdefghijklmnopqrstuvwxyz"
	var available_letters: Array[String] = []
	
	for letter in alphabet:
		if !(letter in choices):
			available_letters.append(letter)
	
	# Randomly select additional letters
	available_letters.shuffle()
	for i in range(number_of_choices):
		choices.append(available_letters[i])
	choices.shuffle()
	
	return choices

func generate_word():
	current_word = DbManager.generate_word()
	
	if current_word:
		progress = 0
		if UI:
			UI.set_question(current_word)
			tts.play(current_word.text)
	else:
		push_error("Failed to generate word from database!")

func _on_completed_problem_wait_time_timeout() -> void:
	generate_word()
