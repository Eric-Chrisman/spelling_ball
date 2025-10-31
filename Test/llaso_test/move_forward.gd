extends CharacterBody3D

func _process(delta: float) -> void:
	var direction = Vector3.ZERO
	if Input.is_action_pressed("down"):
		direction.z = 1
	if Input.is_action_pressed("up"):
		direction.z = -1
	if Input.is_action_pressed("left"):
		direction.x = -1
	if Input.is_action_pressed("right"):
		direction.x = 1
	position += direction * delta * 20
