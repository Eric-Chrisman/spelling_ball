extends Resource
class_name Word

@export var problem_name: String
@export var syallbles: Array[String] # in order of apperance in the word

func _init(problem_name: String, syallbles: Array[String]) -> void:
	self.problem_name = problem_name
	self.syallbles = syallbles
