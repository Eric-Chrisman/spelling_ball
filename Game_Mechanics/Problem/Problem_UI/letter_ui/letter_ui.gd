extends PanelContainer
class_name Letter_UI

var letter: String = "-"

#func _ready() -> void:
#	$CenterContainer/Label.text = letter

func set_letter(letter: String = self.letter, syllable_color: Color = self.modulate, hide_letter: bool = true):
	self.letter = letter
	if hide_letter:
		$CenterContainer/Label.text = "-"
	else:
		$CenterContainer/Label.text = letter.capitalize()
	modulate = syllable_color

func set_correct(is_correct: bool):
	if is_correct:
		$CenterContainer/Label.text = letter.capitalize()
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
