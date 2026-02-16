extends Node3D
class_name Block

@onready var path: Path3D = $Path3D
@onready var path_follow: PathFollow3D = $Path3D/PathFollow3D

func get_curve():
	return path.curve

func get_global_start_position():
	return get_global_position_of_point(0)

func get_global_end_position():
	return get_global_position_of_point(path.curve.point_count - 1)

func get_global_position_of_point(index: int):
	return global_position +  path.curve.get_point_position(index)

func adopt_player(player: Node3D, overhead: float = 0.0):
	player.reparent(path_follow)
	#player.position = path.curve.get_point_position(0)
	path_follow.progress += overhead

func get_ending_angle():
	var point_count: int = path.curve.point_count
	var points: Array[Vector3]
	points.append(path.curve.get_point_position(point_count - 2))
	points.append(path.curve.get_point_position(point_count - 1))
	var direction = points[0].direction_to(points[1])
	return atan2(direction.x, direction.z) + global_rotation.y
