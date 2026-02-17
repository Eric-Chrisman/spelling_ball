extends Resource
class_name Word

# Data Class to Hold a Word
var is_real: bool = true
var text: String
var syllables: Array[Syllable]  

func _init(word_text: String, syllables_array: Array[Syllable], is_real: bool) -> void:
	self.text = word_text
	self.syllables = syllables_array
	self.is_real = is_real

func get_syllable_count() -> int:
	return syllables.size()

func get_letter_count() -> int:
	return text.length()
