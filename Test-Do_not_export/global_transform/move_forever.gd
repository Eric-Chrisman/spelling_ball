extends MeshInstance3D

@export var speed:float = 5000

func _process(delta: float) -> void:
	position.x += speed * delta
