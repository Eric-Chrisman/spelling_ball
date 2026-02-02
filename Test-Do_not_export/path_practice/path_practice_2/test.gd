extends MeshInstance3D
@export var node: Node3D
@export var my_node: Node3D
@export var line: Path3D
@export var path: PathFollow3D

func _ready():
	global_position = node.global_position + (my_node.position)
	#path.add_child(self)

func _process(delta: float) -> void:
	path.progress += delta * 10
