extends Node3D
class_name Game

@onready var rail_system: RailSystem = $Rail_System

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		rail_system.start()
