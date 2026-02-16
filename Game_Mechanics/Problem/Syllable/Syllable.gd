extends Node
class_name Syllable

enum SYLLABLE_TYPE {
	OPEN = 1,
	CLOSED = 2,
	VOWEL_TEAM = 3,
	R_CONTROLLED = 4,
	DIPHTONG = 5,
	CONSONTANT_LE = 6
}

var text: String
var Syllable_Type: SYLLABLE_TYPE

func _init(text: String, syllable_type: SYLLABLE_TYPE) -> void:
	self.text = text
	self.Syllable_Type = Syllable_Type

func length() -> int:
	return text.length()
