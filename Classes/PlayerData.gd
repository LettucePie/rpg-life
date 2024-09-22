extends Object
class_name PlayerData

var player_name : String

func assign_name(new_name : String):
	var sanitized : String = new_name.dedent()
	sanitized = sanitized.substr(0, 31)
	var nono = [
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
		",", ".", "!", "#", "$", "%", "^", "*", "(", ")",
		"_", "+", "=", "<", ">", "|", "\\", "/", "?", ";",
		"[", "]", "{", "}"
	]
	for bad in nono:
		sanitized.replace(bad, "")
	if sanitized.is_empty():
		sanitized = "Godot"
	player_name = sanitized
