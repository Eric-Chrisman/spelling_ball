extends Node3D
class_name Path

@export var max_amount_of_blocks: int = 5
@export var block_of_focus: int = 3
@export var problem_tracker: Problem_Tracker
@export var pickup_spawner: Pickup_Spawner

var sample_path: PackedScene = preload("uid://chxpgb803pbj1")
var sample_start_path: PackedScene = preload("uid://donv80bnd6ag4")
var path_choices = [sample_path]
var blocks: Array[Block] = []
var current_block_index: int = 0

const SPAWN_DELAY_BLOCKS: int = 3
const LETTER_ASSIGN_RANGE: int = 1 
const CLEAR_RANGE: int = 2

var letters_enabled: bool = false

func _ready() -> void:
	await get_tree().process_frame
	_add_block(sample_start_path)
	while blocks.size() < max_amount_of_blocks:
		_add_block(pick_random_path())

func get_current_block() -> Block:
	if blocks.is_empty():
		return null
	current_block_index = clamp(current_block_index, 0, blocks.size() - 1)
	return blocks[current_block_index]

func increment_block() -> Block:
	current_block_index += 1
	
	if current_block_index >= block_of_focus:
		_add_block()
	
	if current_block_index >= blocks.size():
		current_block_index = blocks.size() - 1
	
	# Assign letters to blocks within LETTER_ASSIGN_RANGE of focus
	var focus_index = current_block_index
	var assign_index = focus_index + LETTER_ASSIGN_RANGE
	
	if assign_index < blocks.size():
		var block_to_assign = blocks[assign_index]
		if block_to_assign is Pickup_Block and letters_enabled: 
			var pickup_block: Pickup_Block = block_to_assign as Pickup_Block
			if not pickup_block.has_been_cleared:
				pickup_spawner.assign_letters_to_block(pickup_block)
	
	return get_current_block()

func pick_random_path() -> PackedScene:
	return path_choices[0]

func _add_block(scene: PackedScene = null) -> void:
	if !scene:
		scene = pick_random_path()
	
	var new_block: Block = scene.instantiate()
	add_child(new_block)
	
	# Align new block to previous block
	if blocks.size() > 0:
		var prev_block: Block = blocks.back()
		var prev_end_pos: Vector3 = prev_block.get_global_end_position()
		var new_start_pos: Vector3 = new_block.get_global_start_position()
		var delta: Vector3 = prev_end_pos - new_start_pos
		new_block.global_position += delta
	
	blocks.append(new_block)
	
	# Spawn empty pickups (don't spawn on cleared blocks)
	if blocks.size() > SPAWN_DELAY_BLOCKS and new_block is Pickup_Block:
		var pickup_block: Pickup_Block = new_block as Pickup_Block
		if not pickup_block.has_been_cleared:
			pickup_spawner.spawn_pickups_for_block(pickup_block)
	
	# Remove old blocks if at capacity
	if blocks.size() > max_amount_of_blocks:
		var old_block: Block = blocks.pop_front()
		old_block.queue_free()
		current_block_index = max(current_block_index - 1, 0)

# Hook this up to problem_tracker's "problem_solved" signal in the editor
func clear_pickups_on_problem_solved() -> void:
	var focus_index = current_block_index
	# Clear pickups in CLEAR_RANGE blocks ahead of focus
	for i in range(CLEAR_RANGE + 1):  # +1 to include the range boundary
		var clear_index = focus_index + i
		if clear_index < blocks.size():
			var block = blocks[clear_index]
			if block is Pickup_Block:
				var pickup_block: Pickup_Block = block as Pickup_Block
				pickup_block.clear_pickups()

func enable_letter_assignment() -> void:
	letters_enabled = true
	
	# Retroactively assign letters to any in-range blocks that were skipped
	var focus_index = current_block_index
	for i in range(LETTER_ASSIGN_RANGE + 1):
		var check_index = focus_index + i
		if check_index < blocks.size():
			var block = blocks[check_index]
			if block is Pickup_Block:
				var pickup_block: Pickup_Block = block as Pickup_Block
				if not pickup_block.has_been_cleared:
					pickup_spawner.assign_letters_to_block(pickup_block)
