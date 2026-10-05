extends Resource
class_name Syllable

enum SYLLABLE_TYPE {
	OPEN = 1,
	CLOSED = 2,
	VOWEL_TEAM = 3,
	R_CONTROLLED = 4,
	DIPHTHONG = 5,
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
			return Syllable.SYLLABLE_TYPE.DIPHTHONG
		"consonant-le":
			return Syllable.SYLLABLE_TYPE.CONSONANT_LE
		_:
			return Syllable.SYLLABLE_TYPE.NONE

static func get_string_from_syllable_type(type: Syllable.SYLLABLE_TYPE) -> String:
	match type:
		Syllable.SYLLABLE_TYPE.OPEN:         return "Open"
		Syllable.SYLLABLE_TYPE.CLOSED:       return "Closed"
		Syllable.SYLLABLE_TYPE.MAGIC_E:      return "Magic-e"
		Syllable.SYLLABLE_TYPE.VOWEL_TEAM:   return "Vowel Team"
		Syllable.SYLLABLE_TYPE.R_CONTROLLED: return "R-controlled"
		Syllable.SYLLABLE_TYPE.DIPHTHONG:    return "Diphthong"
		Syllable.SYLLABLE_TYPE.CONSONANT_LE: return "Consonant-le"
		_:                                   return "None"

static var re_consonant_le = RegEx.create_from_string(r"^[bcdfghjklmnpqrstvwxz]le$")
static var re_magic_e_reg  = RegEx.create_from_string(r"[aeiou][^aeiou]+e$")
static var re_magic_e_y    = RegEx.create_from_string(r"[aeiouy][^aeiouy]+e$")
static var re_diphthong    = RegEx.create_from_string(r"oi|oy|ou|ow")
static var re_vowel_team   = RegEx.create_from_string(r"ia|ua|ai|aa|ay|ea|ee|oa|oe|oo|ue|ui|au|aw|ie|ei|ey|io")
static var re_yr           = RegEx.create_from_string(r"yr")
static var re_r_controlled = RegEx.create_from_string(r"[aeiou]r")
static var re_closed_reg   = RegEx.create_from_string(r"[^aeiou]{2,}$")
static var re_closed_y     = RegEx.create_from_string(r"[^aeiouy]{2,}$")
static var re_end_con_reg  = RegEx.create_from_string(r"[bcdfghjklmnpqrstvwxz]$")
static var re_open         = RegEx.create_from_string(r"[aeiouy]$")

static func classify(syl: String) -> Syllable.SYLLABLE_TYPE:
	if syl.is_empty():
		return Syllable.SYLLABLE_TYPE.NONE

	syl = syl.to_lower().strip_edges()

	const VOWELS_WITH_Y := "aeiouy"

	var has_regular_vowel := false
	for c in syl:
		if c in "aeiou":
			has_regular_vowel = true
			break

	# Consonant-le
	if re_consonant_le.search(syl):
		return Syllable.SYLLABLE_TYPE.CONSONANT_LE

	# Magic-e
	var re_magic_e = re_magic_e_reg if has_regular_vowel else re_magic_e_y
	if syl.length() >= 3 and syl.ends_with("e") and re_magic_e.search(syl):
		return Syllable.SYLLABLE_TYPE.MAGIC_E

	# Diphthong
	if re_diphthong.search(syl):
		return Syllable.SYLLABLE_TYPE.DIPHTHONG 

	# Vowel Team
	if re_vowel_team.search(syl):
		return Syllable.SYLLABLE_TYPE.VOWEL_TEAM

	# R-Controlled
	if not has_regular_vowel and re_yr.search(syl):
		return Syllable.SYLLABLE_TYPE.R_CONTROLLED
	if re_r_controlled.search(syl):
		return Syllable.SYLLABLE_TYPE.R_CONTROLLED

	# Closed (cluster or single consonant end)
	var re_closed = re_closed_reg if has_regular_vowel else re_closed_y
	if re_closed.search(syl) or re_end_con_reg.search(syl):
		for c in syl:
			if c in (VOWELS_WITH_Y if not has_regular_vowel else "aeiou"):
				return Syllable.SYLLABLE_TYPE.CLOSED

	# Open
	if re_open.search(syl):
		return Syllable.SYLLABLE_TYPE.OPEN

	return Syllable.SYLLABLE_TYPE.NONE
