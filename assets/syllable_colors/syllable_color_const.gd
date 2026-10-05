extends Node
# Used as a sigleton called SyllableColorConst

func get_color_from_syllable_type(syllable_type: Syllable.SYLLABLE_TYPE) -> Color:
	match syllable_type:
		Syllable.SYLLABLE_TYPE.OPEN:
			return Color.MEDIUM_PURPLE
		Syllable.SYLLABLE_TYPE.CLOSED:
			return Color.CORNFLOWER_BLUE
		Syllable.SYLLABLE_TYPE.VOWEL_TEAM:
			return Color.FIREBRICK
		Syllable.SYLLABLE_TYPE.R_CONTROLLED:
			return Color.ORANGE
		Syllable.SYLLABLE_TYPE.DIPHTHONG:
			return Color.GOLD
		Syllable.SYLLABLE_TYPE.CONSONANT_LE:
			return Color.HOT_PINK
		Syllable.SYLLABLE_TYPE.MAGIC_E:
			return Color.SADDLE_BROWN
		_:
			return Color.WHITE
