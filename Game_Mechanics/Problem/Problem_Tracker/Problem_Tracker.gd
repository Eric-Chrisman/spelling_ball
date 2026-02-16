extends Node
class_name Problem_Tracker

@export var UI: Problem_UI
@export var tts: TTS

@onready var letter_sound_effect_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var current_word: Word
var progress: int = 0

func _ready():
	generate_word()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		tts.play(current_word.text)

# connect signals to this
func letter_hit(letter: String):
	print(letter)
	if current_word.text[progress] == letter:
		progress += 1
		UI.set_letter_correct(progress - 1, true)
		
		if progress == current_word.text.length():
			generate_word()
			# update ui
	else:
		pass # i don't know yet, come back here later
	
	# sound effect
	letter_sound_effect_player.stop()
	var sound_path = "res://Assets/Sound_Effects/letters/alphasounds-" + letter + ".mp3"
	if ResourceLoader.exists(sound_path):
		letter_sound_effect_player.stream = load(sound_path)
	else:
		push_warning("No sound file found at: " + sound_path)
	letter_sound_effect_player.play()

# function gives you the next character that spells the word
func get_next_letter() -> String:
	return current_word.text[progress]

func generate_answer_choices(number_of_choices: int = 3) -> Array[String]:
	var choices: Array[String] = []
	
	# Get the correct letter
	var correct_letter: String = get_next_letter()
	choices.append(correct_letter)
	
	# Define possible letters to choose from (excluding the correct one)
	var alphabet: String = "abcdefghijklmnopqrstuvwxyz"
	var available_letters: Array[String] = []
	
	for letter in alphabet:
		if letter != correct_letter.to_lower():
			available_letters.append(letter)
	
	# Randomly select additional letters
	available_letters.shuffle()
	for i in range(number_of_choices - 1):
		if i < available_letters.size():
			choices.append(available_letters[i])
	
	# Shuffle the choices so the correct answer isn't always first
	choices.shuffle()
	
	return choices

func generate_word():
	# Use DatabaseManager to generate a word
	current_word = DbManager.generate_word()
	
	if current_word:
		progress = 0
		
		# Update UI with the new word
		if UI:
			UI.set_question(current_word)
			tts.play(current_word.text)
	else:
		push_error("Failed to generate word from database!")
