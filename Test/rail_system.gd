extends Path3D

@export var path: Path
@export var speed: float = 10

@onready var follow_path: PathFollow3D = $PathFollow3D
@onready var player_position: Node3D = $PathFollow3D/Node3D
@onready var player: Player = $PathFollow3D/Node3D/CharacterBody3D

var _is_playing: bool = false

func start():
	if _is_playing:
		pass
	curve = path.get_current_target_block().get_curve()
	player.speed_ball_is_moving = speed
	_is_playing = true

func _process(delta: float) -> void:
	if _is_playing:
		follow_path.progress += speed * delta
		if follow_path.progress_ratio == 1:
			var save_position: Vector3 = player_position.global_position
			curve = path.increment().get_curve()
			follow_path.progress_ratio = 0
			player_position.global_position = save_position
