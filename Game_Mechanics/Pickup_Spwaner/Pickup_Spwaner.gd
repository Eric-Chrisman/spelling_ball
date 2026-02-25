extends Node
class_name Pickup_Spwaner
@export var problem_tracker: Problem_Tracker
var text_pickup_data: PackedScene = preload("res://Game_Mechanics/Pickups/text_pickup/text_pickup.tscn")
@export var min_pickups: int = 3
@export var max_pickups: int = 5

func spawn_text_pickup(letter: String) -> Text_Pickup:
	var new_text_pickup: Text_Pickup = text_pickup_data.instantiate()
	new_text_pickup.set_letter(letter)
	new_text_pickup.connect("collected", problem_tracker.letter_hit)
	return new_text_pickup

# Spawn all pickups for a block with empty letters
func spawn_pickups_for_block(block: Pickup_Block) -> void:
	for i in range(randi_range(min_pickups, max_pickups)):
		var text_pickup: Text_Pickup = spawn_text_pickup("")  # Spawn with empty letter
		block.add_pickup(text_pickup)

# Assign letters to unlabeled pickups in a single block
func assign_letters_to_block(block_to_assign: Pickup_Block) -> void:
	var num_of_pickups: int = block_to_assign.pickup_manager.pickups.size()
	var choices: Array[String] = problem_tracker.generate_answer_choices(num_of_pickups)
	var choice_index: int = 0
	
	for pickup in block_to_assign.pickup_manager.pickups:
		if pickup is Text_Pickup:
			var text_pickup: Text_Pickup = pickup as Text_Pickup
			# Check if pickup doesn't have a letter assigned yet
			if text_pickup.letter == "" and choice_index < choices.size():
				text_pickup.set_letter(choices[choice_index])
				choice_index += 1
