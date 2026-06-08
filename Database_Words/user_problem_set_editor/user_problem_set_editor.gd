extends Control

@export var problem_sets_selector: OptionButton
@export var word_list: VBoxContainer
@export var word_editor: user_word_editor
@export var export_button: Button
@export var delete_button: Button
@export var word_list_manager: WordListImporterExporter
@export var add_word_button: Button
@export var problem_set_name_editor: Control
@onready var sound_effect_system: MenuAutoAudio = $MenuAutoAudio

var preloaded_word_ui: PackedScene = preload("res://Database_Words/user_problem_set_editor/word_container.tscn")

func _ready() -> void:
	word_editor.visible = false
	word_list_manager.import_completed.connect(_on_import_completed)
	load_options()

# =========================
# PROBLEM SET SELECTOR
# =========================

func _on_option_button_item_selected(_index: int) -> void:
	load_words()
	update_export_button()

func _on_new_problem_set_pressed() -> void:
	$UserProblemSetName.visible = true

func _on_user_problem_set_name_set_created(set_name: String) -> void:
	load_options()
	_select_problem_set(set_name)

func _on_close_button_pressed() -> void:
	visible = false

func get_selected_problem_set() -> String:
	if problem_sets_selector.selected == -1:
		return ""
	return problem_sets_selector.get_item_text(problem_sets_selector.selected)

func update_export_button() -> void:
	add_word_button.disabled = get_selected_problem_set() == ""
	export_button.disabled = get_selected_problem_set() == ""
	delete_button.disabled = get_selected_problem_set() == ""

# =========================
# WORD LIST
# =========================

func _on_button_pressed() -> void:
	word_editor.prime()

func _on_user_word_editor_ui_add_word(new_word: Word) -> void:
	DbManager.add_word_to_problem_set(new_word, get_selected_problem_set())
	load_words()

func _on_word_delete_pressed(word: Word) -> void:
	DbManager.remove_word_from_problem_set(word, get_selected_problem_set())
	load_words()

func load_options() -> void:
	var selected_set: String = get_selected_problem_set()
	problem_sets_selector.clear()
	clear_words()
	var options: Array[String] = DbManager.get_all_problem_sets()
	for option in options:
		problem_sets_selector.add_item(option)
	_select_problem_set(selected_set)
	load_words()
	update_export_button()

func load_words() -> void:
	clear_words()
	var words = DbManager.get_all_words_from_problem_set(get_selected_problem_set())
	for word in words:
		var word_ui: word_container = preloaded_word_ui.instantiate()
		word_list.add_child(word_ui)
		word_ui.set_text(word.text)
		word_ui.delete_button.connect(_on_word_delete_pressed.bind(word))
		word_ui.delete_button.connect(sound_effect_system.play_audio)

func clear_words() -> void:
	for child in word_list.get_children():
		child.queue_free()

func _on_delete_list_pressed() -> void:
	var problem_set: String = get_selected_problem_set()
	if problem_set != "":
		DbManager.delete_problem_set(problem_set)
	load_options()


# =========================
# IMPORT / EXPORT
# =========================

func _on_import_set_pressed() -> void:
	word_list_manager.open_import_dialog()

func _on_export_list_pressed() -> void:
	word_list_manager.open_export_dialog(get_selected_problem_set())

func _on_import_completed(words: Array[Word], set_name: String) -> void:
	var existing = DbManager.get_all_problem_sets()
	if set_name not in existing:
		DbManager.create_problem_set(set_name)
	
	DbManager.clear_problem_set_words(set_name)
	
	for word in words:
		DbManager.add_word_to_problem_set(word, set_name)
	
	load_options()
	_select_problem_set(set_name)

func _select_problem_set(set_name: String) -> void:
	for i in problem_sets_selector.item_count:
		if problem_sets_selector.get_item_text(i) == set_name:
			problem_sets_selector.select(i)
			load_words()
			update_export_button()
			return

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		if (
			!add_word_button.disabled and
			 visible and
			 !word_editor.visible and
			 !problem_set_name_editor.visible
			):
				add_word_button.emit_signal("pressed")
