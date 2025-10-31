extends Node3D
class_name BALSE

@export var tail:Node3D
@export var head:Node3D
@export var path:Path3D
@export var text:Label3D
@export var mesh:MeshInstance3D
var threshold: float = 2000

func _ready() -> void:
	text.text = name
	
func set_color(value: int):
	# Make sure this mesh has its own copy of the material
	if mesh.get_active_material(0) != null:
		mesh.set_surface_override_material(0, mesh.get_active_material(0).duplicate())
	else:
		mesh.set_surface_override_material(0, StandardMaterial3D.new())

	var mat = mesh.get_active_material(0)

	if value == 0:
		mat.albedo_color = Color(1, 0, 0) # red
	else:
		mat.albedo_color = Color(0, 0, 1) # blue
