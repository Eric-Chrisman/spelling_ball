extends Node3D
class_name Block

@export var start: Node3D
@export var end: Node3D
@export var path: Path3D

func get_curve():
	return path.curve

func update_curve() -> void:
	for i in range(path.curve.get_point_count()):
		var local_point := path.curve.get_point_position(i)
		path.curve.set_point_position(i, local_point + global_position)
