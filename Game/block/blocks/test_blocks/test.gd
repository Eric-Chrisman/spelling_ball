extends Node3D
@export var block1: Block
@export var block2: Block

func _ready():
	block1.global_rotation = block2.end.global_rotation
	var move_vector: Vector3 = block2.end.global_position - block1.start.global_position
	print(move_vector)
	block1.global_position += move_vector
	
	print(block2.rotation)
	print(block2.end.rotation)
	print(block2.end.global_rotation)
