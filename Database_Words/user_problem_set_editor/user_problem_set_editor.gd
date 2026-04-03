extends Control

@export var problem_sets_selector: OptionButton
@export var word_list: VBoxContainer
@export var word_editor: user_word_editor

var preloaded_word_ui: PackedScene = preload("res://Database_Words/user_problem_set_editor/word_container.tscn")

func _ready() -> void:
	word_editor.visible = false
	load_options()

# add word
func _on_button_pressed() -> void:
	word_editor.visible = true

func _on_option_button_item_selected(index: int) -> void:
	load_words()  # FIX: was load_options()

func _on_new_problem_set_pressed() -> void:
	$UserProblemSetName.visible = true

func _on_user_problem_set_name_menu_closed() -> void:
	load_options()

func _on_close_button_pressed() -> void:
	visible = false

func load_options():
	problem_sets_selector.clear()
	clear_words()
	var options: Array[String] = DbManager.get_all_problem_sets()
	for option in options:
		problem_sets_selector.add_item(option)  # FIX: removed manual index
	load_words()

func load_words():
	clear_words()
	var words = DbManager.get_all_words_from_problem_set(get_selected_problem_set())
	for word in words:
		var word_ui: word_container = preloaded_word_ui.instantiate()
		word_list.add_child(word_ui)
		word_ui.set_text(word.text)
		word_ui.delete_button.connect(_on_word_delete_pressed.bind(word))

func clear_words():
	for child in word_list.get_children():
		child.queue_free()

func get_selected_problem_set() -> String:
	return problem_sets_selector.get_item_text(problem_sets_selector.selected)  # FIX: was get_selected_id()

func _on_user_word_editor_ui_add_word(new_word: Word) -> void:
	DbManager.add_word_to_problem_set(new_word, get_selected_problem_set())
	load_words()

func _on_word_delete_pressed(word: Word) -> void:
	DbManager.remove_word_from_problem_set(word, get_selected_problem_set())
	load_words()
