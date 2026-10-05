extends AudioStreamPlayer2D
class_name MenuAutoAudio

@export var connected_buttons: Array[Button]

func _ready() -> void:
	for button: Button in connected_buttons:
		button.connect("pressed", play_audio)

func play_audio():
	play()
