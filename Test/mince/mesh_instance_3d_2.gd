@tool
extends MeshInstance3D

@export_range(0, 30, 0.2, "or_greater") var value: float = 2

func _physics_process(delta: float) -> void:
	rotate_y(value * delta)
