extends Node3D
class_name Path

var sample_path: PackedScene = preload("res://Game/block/blocks/test_blocks/test_block.tscn")
var left_turn_path: PackedScene = preload("res://Game/block/blocks/test_blocks/turn_left_test_block.tscn")
var sample_start_path: PackedScene = preload("res://Game/block/blocks/test_blocks/test_block_start.tscn")

var path_choices = [left_turn_path, sample_path]

@export var max_amount_of_blocks: int = 5
@export var block_of_focus: int = 3

var blocks: Array[Block] = []
var current_block: int = 0

func _ready() -> void:
	# Add the starting block first
	_add_block(sample_start_path)
	
	# Fill the rest of the path up to the max limit
	while blocks.size() < max_amount_of_blocks:
		_add_block(left_turn_path)

func _add_block(scene: PackedScene = null) -> void:
	if !scene:
		scene = pick_random_path()
	
	var new_block: Node3D = scene.instantiate()
	add_child(new_block)

	# Attach the new block to the end of the last one
	if blocks.size() > 0:
		var prev_block: Block = blocks.back()
		var prev_end: Node3D = prev_block.end
		new_block.rotation = prev_end.global_rotation
		
		var new_start: Node3D = new_block.start
		new_block.global_position += prev_end.global_position - new_start.global_position
		
		new_block.update_curve()

	blocks.append(new_block)

	# Always keep only max_amount_of_blocks in memory
	if blocks.size() > max_amount_of_blocks:
		var old_block: Node3D = blocks.pop_front()
		old_block.queue_free()
		# Adjust current_block so it still points to the same logical block
		current_block = max(current_block - 1, 0)

func increment() -> Block:
	# Move focus forward
	current_block += 1

	# When player has moved beyond the focus block, start the rolling path
	if current_block >= block_of_focus:
		_add_block()

	return get_current_target_block()

func get_current_target_block() -> Block:
	# Clamp to array bounds to avoid errors
	current_block = clamp(current_block, 0, blocks.size() - 1)
	return blocks[current_block]

func pick_random_path() -> PackedScene:
	return path_choices[randi_range(0, path_choices.size() - 1)]
