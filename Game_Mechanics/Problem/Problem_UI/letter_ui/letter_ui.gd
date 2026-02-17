extends PanelContainer
class_name Letter_UI

var letter: String = ""

func _ready() -> void:
	$CenterContainer/Label.text = "-"

func set_letter(letter: String, syllable_color: Color):
	self.letter = letter
	$CenterContainer/Label.modulate = syllable_color

func set_correct(is_correct: bool):
	if is_correct:
		$CenterContainer/Label.text = letter.capitalize()
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
