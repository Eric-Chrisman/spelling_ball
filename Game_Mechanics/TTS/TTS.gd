extends Node3D
class_name TTS

var voices = DisplayServer.tts_get_voices_for_language("en")
var voice_id = voices[0] if voices.size() > 0 else ""
var tts_disabled: bool = false

var placeholder_callouts: Array[String] = [
	"Everything is working.",
	"Nice.",
	"Listen carefully.",
	"Keyboard wizard.",
	"No words.",
	"Button time.",
	"Hello?",
	"Ready?",
	"Click.",
	"Speak."
]

func play(text_to_say: String) -> void:
	if DisplayServer.tts_is_speaking() or tts_disabled:
		return
	var final_text := text_to_say
	if final_text.strip_edges() == "":
		final_text = placeholder_callouts[randi_range(0, placeholder_callouts.size() - 1)]
	DisplayServer.tts_speak(final_text, voice_id, 100)
