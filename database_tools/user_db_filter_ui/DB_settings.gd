extends Control
# i hate ui glue so much
signal exit_pressed

@onready var fake_words_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/fake_words
@onready var min_word_length: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/min_word_length
@onready var max_word_length: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/max_word_length
@onready var min_syllable: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer4/min_syllables
@onready var max_syllable: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer5/max_syllables
@onready var open_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CheckBox
@onready var closed_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CheckBox2
@onready var magic_e_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CheckBox3
@onready var r_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CheckBox4
@onready var vowel_team_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CheckBox5
@onready var le_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CheckBox6
@onready var dipthong_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CheckBox7
@onready var problem_set_selector: OptionButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/OptionButton

var db_manager: Node

func ready_menu():
	load_problem_sets()
	visible = true

func _ready():
	db_manager = get_node("/root/DbManager")

	fake_words_slider.value_changed.connect(_on_fake_words_changed)
	min_word_length.value_changed.connect(_on_min_word_length_changed)
	max_word_length.value_changed.connect(_on_max_word_length_changed)
	min_syllable.value_changed.connect(_on_min_syllable_changed)
	max_syllable.value_changed.connect(_on_max_syllable_changed)

	open_box.toggled.connect(_on_syllable_type_toggled.bind(open_box, "Open"))
	closed_box.toggled.connect(_on_syllable_type_toggled.bind(closed_box, "Closed"))
	magic_e_box.toggled.connect(_on_syllable_type_toggled.bind(magic_e_box, "Magic-e"))
	r_box.toggled.connect(_on_syllable_type_toggled.bind(r_box, "R-controlled"))
	vowel_team_box.toggled.connect(_on_syllable_type_toggled.bind(vowel_team_box, "Vowel Team"))
	le_box.toggled.connect(_on_syllable_type_toggled.bind(le_box, "Consonant-le"))
	dipthong_box.toggled.connect(_on_syllable_type_toggled.bind(dipthong_box, "Diphthong"))

	_sync_all()

func load_problem_sets():
	problem_set_selector.clear()
	problem_set_selector.add_item("None")  # index 0 = no problem set
	var sets: Array[String] = db_manager.get_all_problem_sets()
	for s in sets:
		problem_set_selector.add_item(s)
	# Restore previously selected set if any
	if db_manager.selected_problem_set == "":
		problem_set_selector.selected = 0
	else:
		for i in range(problem_set_selector.item_count):
			if problem_set_selector.get_item_text(i) == db_manager.selected_problem_set:
				problem_set_selector.selected = i
				break

func _sync_all():
	db_manager.fake_word_probability = fake_words_slider.value
	db_manager.min_word_length = int(min_word_length.value)
	db_manager.max_word_length = int(max_word_length.value)
	db_manager.min_syllables = int(min_syllable.value)
	db_manager.max_syllables = int(max_syllable.value)
	_update_allowed_syllable_types()

func _on_fake_words_changed(value: float):
	db_manager.fake_word_probability = value

func _on_min_word_length_changed(value: float):
	if value > max_word_length.value:
		max_word_length.value = value
	db_manager.min_word_length = int(value)

func _on_max_word_length_changed(value: float):
	if value < min_word_length.value:
		min_word_length.value = value
	db_manager.max_word_length = int(value)

func _on_min_syllable_changed(value: float):
	if value > max_syllable.value:
		max_syllable.value = value
	db_manager.min_syllables = int(value)

func _on_max_syllable_changed(value: float):
	if value < min_syllable.value:
		min_syllable.value = value
	db_manager.max_syllables = int(value)

func _on_syllable_type_toggled(_pressed: bool, _box: CheckBox, _type: String):
	if not _pressed:
		if _count_checked_syllable_boxes() == 0:
			_box.set_pressed_no_signal(true)
			return
	_update_allowed_syllable_types()

func _count_checked_syllable_boxes() -> int:
	var count = 0
	for box in [open_box, closed_box, magic_e_box, r_box, vowel_team_box, le_box, dipthong_box]:
		if box.button_pressed:
			count += 1
	return count

func _update_allowed_syllable_types():
	var allowed: Array[String] = []
	if open_box.button_pressed:      allowed.append("Open")
	if closed_box.button_pressed:    allowed.append("Closed")
	if magic_e_box.button_pressed:   allowed.append("Magic-e")
	if r_box.button_pressed:         allowed.append("R-controlled")
	if vowel_team_box.button_pressed: allowed.append("Vowel Team")
	if le_box.button_pressed:        allowed.append("Consonant-le")
	if dipthong_box.button_pressed:  allowed.append("Diphthong")
	db_manager.allowed_syllable_types = allowed

func _on_button_pressed() -> void:
	if problem_set_selector.selected == 0:
		db_manager.selected_problem_set = ""
	else:
		db_manager.selected_problem_set = problem_set_selector.get_item_text(problem_set_selector.selected)

	db_manager.refresh_word_pool()
	emit_signal("exit_pressed")
