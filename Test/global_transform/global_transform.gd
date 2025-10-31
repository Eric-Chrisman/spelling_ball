extends Node3D

# Amount of distance before shifting
@export var threshold: float = 2000

# Reference to main camera
@export var camera: Camera3D

func shift_origin() -> void:
	global_transform.origin -= camera.global_transform.origin
	print("World shifted to " + str(global_transform.origin))

func _physics_process(delta: float) -> void:
	#print(camera.global_transform.origin.length())
	if(camera.global_transform.origin.length() > threshold && camera != null):
		shift_origin()
		print()
