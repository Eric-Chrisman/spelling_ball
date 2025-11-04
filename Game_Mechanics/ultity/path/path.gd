extends Node3D
class_name Path

@export var max_amount_of_blocks: int = 5
@export var block_of_focus: int = 3

var sample_path: PackedScene = preload("res://Assets/Blocks/Test_blocks/strait_block.tscn")
var left_turn_path: PackedScene = preload("res://Assets/Blocks/Test_blocks/left_curve_block.tscn")
var sample_start_path: PackedScene = preload("res://Assets/Blocks/Test_blocks/start_block.tscn")

var path_choices = [left_turn_path, sample_path]

var blocks: Array[Block] = []
var current_block_index: int = 0

func _ready() -> void:
	# Add the starting block first (guaranteed seed block)
	_add_block(sample_start_path)
	# Fill up to the desired number of initial blocks
	while blocks.size() < max_amount_of_blocks:
		_add_block(pick_random_path())

func get_current_block() -> Block:
	if blocks.is_empty():
		return null
	current_block_index = clamp(current_block_index, 0, blocks.size() - 1)
	return blocks[current_block_index]

# Advance the logical current block index and ensure new blocks are added
func increment_block() -> Block:
	current_block_index += 1

	# If we've moved past the focus threshold, append another block
	if current_block_index >= block_of_focus:
		_add_block()

	# If the index is beyond current blocks (rare but safe), clamp it
	if current_block_index >= blocks.size():
		current_block_index = blocks.size() - 1

	return get_current_block()

func pick_random_path() -> PackedScene:
	return path_choices[randi_range(0, path_choices.size() - 1)]

func _add_block(scene: PackedScene = null) -> void:
	if !scene:
		scene = pick_random_path()
	
	var new_block: Block = scene.instantiate()
	add_child(new_block)

	# If there is a previous block, align the new block so its start position
	# matches the previous block's end position using the Block API.
	if blocks.size() > 0:
		# Align rotation using the previous block’s ending angle
		
		var prev_block: Block = blocks.back()
		new_block.global_rotation.y = rad_to_deg(prev_block.get_ending_angle())
		var prev_end_pos: Vector3 = prev_block.get_global_end_position()
		var new_start_pos: Vector3 = new_block.get_global_start_position()
		var delta: Vector3 = prev_end_pos - new_start_pos
		
		# Align position
		new_block.global_position += delta
	
	# Append block to the list
	blocks.append(new_block)
	
	# If we've exceeded capacity, free the oldest block and adjust indices.
	if blocks.size() > max_amount_of_blocks:
		var old_block: Block = blocks.pop_front()
		old_block.queue_free()
		# Keep the current_block_index pointing to the same logical block
		current_block_index = max(current_block_index - 1, 0)
