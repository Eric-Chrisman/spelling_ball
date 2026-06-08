extends Label

func _ready() -> void:
	$rotate.play("sin_grow")
	$size.play("new_animation")
