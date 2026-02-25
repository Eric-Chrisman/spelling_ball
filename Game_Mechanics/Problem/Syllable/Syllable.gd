extends Node
class_name Syllable

enum SYLLABLE_TYPE {
	OPEN = 1,
	CLOSED = 2,
	VOWEL_TEAM = 3,
	R_CONTROLLED = 4,
	DIPHTONG = 5,
	CONSONANT_LE = 6,
	MAGIC_E = 7,
	NONE = 0
}

var text: String
var Syllable_Type: SYLLABLE_TYPE

func _init(text: String, syllable_type: SYLLABLE_TYPE) -> void:
	self.text = text
	self.Syllable_Type = syllable_type

func length() -> int:
	return text.length()

static func get_syllable_type_from_string(text: String) -> Syllable.SYLLABLE_TYPE:
	match text.to_lower():
		"open":
			return Syllable.SYLLABLE_TYPE.OPEN
		"closed":
			return Syllable.SYLLABLE_TYPE.CLOSED
		"magic-e":
			return Syllable.SYLLABLE_TYPE.MAGIC_E
		"vowel team":
			return Syllable.SYLLABLE_TYPE.VOWEL_TEAM
		"r-controlled":
			return Syllable.SYLLABLE_TYPE.R_CONTROLLED
		"diphthong":
			return Syllable.SYLLABLE_TYPE.DIPHTONG
		"consonant-le":
			return Syllable.SYLLABLE_TYPE.CONSONANT_LE
		_:
			return Syllable.SYLLABLE_TYPE.NONE
