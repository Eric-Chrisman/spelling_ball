extends TextEdit

@export var letter_limit: int = 30
var syllable_selector_ui: Array[Control] = []

func _handle_unicode_input(unicode_char: int, caret_index: int) -> void:
	var char_candidate: String = String.chr(unicode_char).to_lower()
	if text.length() <= letter_limit and ((char_candidate >= "a" and char_candidate <= "z") or char_candidate == ";"):
		insert_text_at_caret(char_candidate, caret_index)
