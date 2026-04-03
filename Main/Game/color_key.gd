extends ColorRect

@export var syllable_type: Syllable.SYLLABLE_TYPE

func _ready() -> void:
	if syllable_type:
		color = SyllableColorConst.get_color_from_syllable_type(syllable_type)
