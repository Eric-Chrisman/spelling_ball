extends Node3D

func correct_buzzer(pitch_coefficient: float) -> void:
	$correct.stop()
	$correct.pitch_scale = pitch_coefficient
	$correct.play()

func incorrect_buzzer() -> void:
	$incorrect.play()
