extends CharacterBody3D
class_name Player

enum LANES {
	LEFT = 0,
	MIDDLE = 1,
	RIGHT = 2
}

@export var lane_width: float = 100
var current_lane: LANES = LANES.MIDDLE

@export var shadow_blob: MeshInstance3D

var jump_strength: int = 5
var gravity_strength: float = 9.8
var fast_fall_multiplier: float = 2

var speed_ball_is_moving: float = 0
const RADIUS_OF_BALL: float = 0.5

func _process(delta: float) -> void:
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_just_pressed("up"):
			velocity.y = jump_strength
	else:
		if velocity.y > 0:
			velocity.y -= gravity_strength * delta
		else:
			velocity.y -= gravity_strength * delta * fast_fall_multiplier
	
	if Input.is_action_just_pressed("left"):
		_process_lane_change(false)
	elif Input.is_action_just_pressed("right"):
		_process_lane_change(true)
	
	rotate_x(speed_ball_is_moving / RADIUS_OF_BALL * delta * -1)
	
	move_and_slide()

# false for going left, true for right
func _process_lane_change(direction: bool):
	# right direction
	if direction:
		if current_lane == LANES.LEFT:
			current_lane = LANES.MIDDLE
			position.x = 0
		elif current_lane == LANES.MIDDLE:
			current_lane = LANES.RIGHT
			position.x = lane_width
	# left direction
	else:
		if current_lane == LANES.RIGHT:
			current_lane = LANES.MIDDLE
			position.x = 0
		elif current_lane == LANES.MIDDLE:
			current_lane = LANES.LEFT
			position.x = -lane_width

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + Vector3.DOWN * 200)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if result:
		shadow_blob.global_position = Vector3(global_position.x, result.position.y + 0.01, global_position.z)
		var dist = global_position.y - result.position.y
		var s = clamp(1.0 - dist * 0.1, 0.1, 1.0)
		shadow_blob.scale = Vector3(s, s, s)
		shadow_blob.global_position.y += 0.1
