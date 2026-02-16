extends Node3D
class_name Pickup_Manager
@export var available_spots: Array[Node3D]
var pickups: Array[Pickup]

func place_pickup(pickup: Pickup) -> bool:
	if is_at_capacity():
		return false
	
	var picked_location_index: int = randi_range(0, available_spots.size() - 1)
	var picked_location: Node3D = available_spots[picked_location_index]
	available_spots.pop_at(picked_location_index)
	picked_location.add_child(pickup)
	pickup.position = Vector3.ZERO
	
	pickups.append(pickup)
	
	return true

func is_at_capacity() -> bool:
	return available_spots.size() == 0

func get_capacity() -> int:
	return available_spots.size()

func clear_all_pickups():
	for pickup in pickups:
		pickup.queue_free()
	pickups.clear()
