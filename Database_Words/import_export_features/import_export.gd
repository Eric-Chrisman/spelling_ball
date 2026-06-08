extends Node
class_name WordListImporterExporter

signal import_completed(words: Array[Word], set_name: String)

var _last_dir: String = ""

# =========================
# IMPORT
# =========================

func open_import_dialog() -> void:
	DisplayServer.file_dialog_show(
		"Import Word List",
		_last_dir, "",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
		["*.spl"],
		_on_import_file_selected
	)

func _on_import_file_selected(status: bool, paths: PackedStringArray, _filter_index: int) -> void:
	if not status or paths.is_empty():
		return
	_last_dir = paths[0].get_base_dir()

	var file = FileAccess.open(paths[0], FileAccess.READ)
	if file == null:
		push_error("Failed to open import file: " + paths[0])
		return

	var content = file.get_as_text()
	file.close()

	# Set name is the filename without extension
	var set_name = paths[0].get_file().get_basename()

	var words = _parse_and_validate(content)
	emit_signal("import_completed", words, set_name)


func _parse_and_validate(content: String) -> Array[Word]:
	var words: Array[Word] = []
	var skipped := 0

	for raw_line in content.split("\n"):
		var line = raw_line.strip_edges()

		if line.is_empty():
			continue

		# Only a-z and semicolons allowed (mirrors your TextEdit validator)
		var line_valid := true
		for c in line:
			if not ((c >= "a" and c <= "z") or c == ";"):
				line_valid = false
				break
		if not line_valid:
			skipped += 1
			continue

		var parts = line.split(";")

		# Every chunk between semicolons must be non-empty
		var parts_valid := true
		for part in parts:
			if part.strip_edges().is_empty():
				parts_valid = false
				break
		if not parts_valid:
			skipped += 1
			continue

		var syllables: Array[Syllable] = []
		for part in parts:
			var syl_text = part.strip_edges()
			syllables.append(Syllable.new(syl_text, Syllable.classify(syl_text)))

		var word_text = "".join(parts)
		words.append(Word.new(word_text, syllables, true))

	if skipped > 0:
		print("Import: skipped %d invalid lines." % skipped)

	return words


# =========================
# EXPORT
# =========================

func open_export_dialog(set_name: String) -> void:
	DisplayServer.file_dialog_show(
		"Export Word List",
		_last_dir, set_name + ".spl",
		false,
		DisplayServer.FILE_DIALOG_MODE_SAVE_FILE,
		["*.spl"],
		_on_export_file_selected.bind(set_name)
	)

func _on_export_file_selected(status: bool, paths: PackedStringArray, _filter_index: int, set_name: String) -> void:
	if not status or paths.is_empty():
		return
	_last_dir = paths[0].get_base_dir()

	var words = DbManager.get_all_words_from_problem_set(set_name)
	var lines: Array[String] = []

	for word in words:
		var parts: Array[String] = []
		for syl in word.syllables:
			parts.append(syl.text)
		lines.append(";".join(parts))

	var file = FileAccess.open(paths[0], FileAccess.WRITE)
	if file == null:
		push_error("Failed to open export file: " + paths[0])
		return

	file.store_string("\n".join(lines))
	file.close()
	print("Exported %d words to %s" % [words.size(), paths[0]])
