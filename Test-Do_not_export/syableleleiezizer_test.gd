extends Node2D
func _ready() -> void:
	var tests := {
		# Consonant-le
		"tle": Syllable.SYLLABLE_TYPE.CONSONANT_LE,
		"ble": Syllable.SYLLABLE_TYPE.CONSONANT_LE,
		"ple": Syllable.SYLLABLE_TYPE.CONSONANT_LE,

		# Magic-e
		"make": Syllable.SYLLABLE_TYPE.MAGIC_E,
		"bike": Syllable.SYLLABLE_TYPE.MAGIC_E,
		"hope": Syllable.SYLLABLE_TYPE.MAGIC_E,
		"cute": Syllable.SYLLABLE_TYPE.MAGIC_E,

		# Diphthong
		"oil": Syllable.SYLLABLE_TYPE.DIPHTHONG,
		"boy": Syllable.SYLLABLE_TYPE.DIPHTHONG,
		"out": Syllable.SYLLABLE_TYPE.DIPHTHONG,
		"cow": Syllable.SYLLABLE_TYPE.DIPHTHONG,

		# Vowel Team
		"rain": Syllable.SYLLABLE_TYPE.VOWEL_TEAM,
		"feet": Syllable.SYLLABLE_TYPE.VOWEL_TEAM,
		"boat": Syllable.SYLLABLE_TYPE.VOWEL_TEAM,
		"play": Syllable.SYLLABLE_TYPE.VOWEL_TEAM,
		"pie": Syllable.SYLLABLE_TYPE.VOWEL_TEAM,

		# R-Controlled
		"car": Syllable.SYLLABLE_TYPE.R_CONTROLLED,
		"her": Syllable.SYLLABLE_TYPE.R_CONTROLLED,
		"bird": Syllable.SYLLABLE_TYPE.R_CONTROLLED,
		"for": Syllable.SYLLABLE_TYPE.R_CONTROLLED,
		"lyr": Syllable.SYLLABLE_TYPE.R_CONTROLLED,

		# Closed
		"cat": Syllable.SYLLABLE_TYPE.CLOSED,
		"sit": Syllable.SYLLABLE_TYPE.CLOSED,
		"jump": Syllable.SYLLABLE_TYPE.CLOSED,
		"gym": Syllable.SYLLABLE_TYPE.CLOSED,
		"myth": Syllable.SYLLABLE_TYPE.CLOSED,

		# Open
		"go": Syllable.SYLLABLE_TYPE.OPEN,
		"me": Syllable.SYLLABLE_TYPE.OPEN,
		"hi": Syllable.SYLLABLE_TYPE.OPEN,
		"by": Syllable.SYLLABLE_TYPE.OPEN,
		"no": Syllable.SYLLABLE_TYPE.OPEN,
	}

	var passed := 0
	var failed := 0

	for syl in tests:
		var expected: Syllable.SYLLABLE_TYPE = tests[syl]
		var result: Syllable.SYLLABLE_TYPE = Syllable.classify(syl)
		if result == expected:
			print("PASS | '%s' => %s" % [syl, Syllable.SYLLABLE_TYPE.keys()[result]])
			passed += 1
		else:
			print("FAIL | '%s' => got %s, expected %s" % [
				syl,
				Syllable.SYLLABLE_TYPE.keys()[result],
				Syllable.SYLLABLE_TYPE.keys()[expected]
			])
			failed += 1

	print("---")
	print("Results: %d passed, %d failed out of %d tests" % [passed, failed, passed])
