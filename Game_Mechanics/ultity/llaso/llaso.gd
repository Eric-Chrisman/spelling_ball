extends Node3D

@export_range(10, 10000, 10) var threshold: float = 2000
@export var node_to_llaso: Node3D

# maybe change to effect only zx plane?
func _process(delta: float) -> void:
	if node_to_llaso.position.length() > threshold:
		print("moving")
		for node in get_children():
			if node != node_to_llaso:
				print(node)
				node.position -= node_to_llaso.position
		node_to_llaso.position = Vector3.ZERO
