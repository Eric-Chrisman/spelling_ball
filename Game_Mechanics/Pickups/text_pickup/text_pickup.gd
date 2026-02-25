extends Pickup
class_name Text_Pickup

var letter: String = "+++ERROR+++"
@onready var letter_sound_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@export var label: Label3D
signal collected(letter: String)

func _ready() -> void:
	set_letter(letter)

func set_letter(new_letter: String):
	letter = new_letter
	label.text = letter.capitalize()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		emit_signal("collected", letter)
		letter_sound_player.play()
