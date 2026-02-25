extends Node3D
class_name TTS

var voices = DisplayServer.tts_get_voices_for_language("en")
var voice_id = voices[0]

func play(text_to_say: String) -> void:
	if !DisplayServer.tts_is_speaking():
	#splayServer.tts_stop()
		DisplayServer.tts_speak(text_to_say, voice_id, 100)
