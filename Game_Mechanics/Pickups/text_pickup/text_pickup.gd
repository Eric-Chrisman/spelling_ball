extends Pickup
class_name Text_Pickup

var letter: String = "+++ERROR+++"
@export var label: Label3D

func _ready() -> void:
	set_letter(letter)

func set_letter(new_letter: String):
	letter = new_letter
	label.text = letter
