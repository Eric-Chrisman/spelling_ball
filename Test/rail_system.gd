extends Node3D
class_name RailSystem

@export var path: Path
@export var speed: float = 10.0

@onready var player: Node3D = $Player
var current_block: Block
var is_playing: bool = false

func start():
	if is_playing:
		return
	
	is_playing = true
	current_block = path.get_current_block()
	current_block.adopt_player(player)
	print("Player adopted by first block")

func _process(delta: float) -> void:
	if !is_playing or player == null:
		return

	var follow: PathFollow3D = current_block.path_follow
	follow.progress += speed * delta

	# Reached end of block?
	if follow.progress_ratio >= 1.0:
		transition_to_next_block()

func transition_to_next_block() -> void:
	var old_block = current_block
	current_block = path.increment_block()

	if current_block == null:
		print("No next block found")
		return

	# Optional: small continuity offset to prevent teleport gap
	#var overhead = old_block.path_follow.progress - old_block.path_follow.curve.get_baked_length()
	var overhead = 0
	current_block.adopt_player(player, overhead)
	print("Transitioned player to next block")
