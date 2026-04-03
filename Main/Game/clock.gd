extends Node
class_name Clock

@export var word_ui: Label
@export var clock_ui: Label

var time_expired: float = 0.0
var clock_active: bool = false
var words_completed: int = 0

func _ready():
	word_ui.text = str(words_completed)

func _process(delta: float) -> void:
	if clock_active:
		time_expired += delta
	var minutes: int = int(time_expired) / 60
	var seconds: int = int(time_expired) % 60
	clock_ui.text = "%02d:%02d" % [minutes, seconds]
	clock_ui.text = "%02d:%02d.%d" % [minutes, seconds, int(fmod(time_expired, 1.0) * 10)]

func word_completed():
	words_completed += 1
	word_ui.text = str(words_completed)

func _on_problem_tracker_problem_solved() -> void:
	word_completed()
