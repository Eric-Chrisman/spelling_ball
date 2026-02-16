extends Resource
class_name Word

# Data Class to Hold a Word
var text: String
var syllables: Array[Syllable]  

func _init(word_text: String, syllables_array: Array[Syllable]) -> void:
	self.text = word_text
	self.syllables = syllables_array

func get_syllable_count() -> int:
	return syllables.size()

func get_letter_count() -> int:
	return text.length()
