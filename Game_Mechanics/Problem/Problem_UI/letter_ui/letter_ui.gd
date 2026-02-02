extends PanelContainer
class_name Letter_UI

func set_letter(letter: String):
	$CenterContainer/Label.text = letter.capitalize()

func set_correct(is_correct: bool):
	if is_correct:
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
