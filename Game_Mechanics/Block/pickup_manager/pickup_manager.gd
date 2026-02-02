extends Node3D
class_name Pickup_Manager

@export var available_spots: Array[Node3D]
var text_pickup_data = preload("res://Game_Mechanics/Pickups/text_pickup/text_pickup.tscn")
var pickups: Array[Pickup]

func place_pickup(pickup: Pickup):
	if is_at_capacity():
		return                                                                                                                                                                                                                                                                                                                                                                                   #hello                   
	var picked_location_index: int = randi_range(0, available_spots.size())
	var picked_location: Node3D = available_spots[picked_location_index]
	available_spots.pop_at(picked_location_index)
	pickup.position = picked_location.position

func is_at_capacity() -> int:
	return available_spots.size() == 0
