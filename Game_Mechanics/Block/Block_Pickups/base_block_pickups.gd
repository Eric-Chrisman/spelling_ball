extends Block
class_name Pickup_Block
@export var pickup_manager: Pickup_Manager
var has_been_cleared: bool = false  # ← NEW: Track if block was cleared

func add_pickup(pickup: Pickup) -> bool:
	return pickup_manager.place_pickup(pickup)

func clear_pickups() -> void:
	pickup_manager.clear_all_pickups()
	has_been_cleared = true  # ← NEW: Mark as cleared

func get_pickup_capacity() -> int:
	return pickup_manager.get_capacity()
