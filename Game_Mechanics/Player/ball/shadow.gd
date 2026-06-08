extends MeshInstance3D

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + Vector3.DOWN * 20.0)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if result:
		global_position = result.position + Vector3.UP * 0.01
		
		# scale down as ball gets higher
		var dist = global_position.y - result.position.y
		var s = clamp(1.0 - dist * 0.1, 0.1, 1.0)
		scale = Vector3(s, s, s)
