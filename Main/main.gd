extends Node
class_name Main

var spelling_game = preload("res://Main/Game/Game.tscn")
var game_instance: Game = null

func _ready():
	await get_tree().process_frame
	load_game()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if !game_instance or game_instance.game_in_play:
			_on_reset_game()
		elif !game_instance.game_in_play and game_instance.ready_to_go:
			$Main_Menu/Main_Menu.visible = true
			game_instance.unprime_game()
		else:
			get_tree().quit()

func load_game():
	$Main_Menu/veil.color = Color.BLACK
	game_instance = spelling_game.instantiate()
	add_child(game_instance)
	# game_instance.connect("reset_game", _on_reset_game)
	$Main_Menu/veil/lift_veil.play("new_animation")

func _on_reset_game():
	$Main_Menu/veil.color = Color.BLACK
	game_instance.queue_free()
	game_instance = null
	await get_tree().process_frame
	load_game()
	$Main_Menu/Main_Menu.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	game_instance.prime_game()
	$Main_Menu/Main_Menu.visible = false

func _on_intervetion_pressed() -> void:
	$Main_Menu.visible = false
	$Interventist_Settings.visible = true

func _on_db_settings_exit_pressed() -> void:
	$Main_Menu.visible = true
	$Interventist_Settings.visible = false
