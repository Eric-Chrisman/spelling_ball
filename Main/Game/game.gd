extends Node3D
class_name Game

var ready_to_go: bool = false
var game_in_play: bool = false

func _ready():
	$tutorial/Control.modulate = Color(1,1,1,0)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("up") and ready_to_go:
		game_in_play = true
		ready_to_go = false
		$tutorial/Timer.start()
		$Rail_System.start()
		$Problem_Tracker.generate_word()
		$path.enable_letter_assignment()

func prime_game():
	ready_to_go = true
	$tutorial/AnimationPlayer.play("fade_in")

func unprime_game():
	ready_to_go = false
	$tutorial/AnimationPlayer.stop()
	$tutorial/Control.modulate = Color.WHITE

func _on_timer_timeout() -> void:
	$tutorial/AnimationPlayer.play("fade_out")
