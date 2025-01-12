extends Object
class_name PlayerData

var player_name : String
var player_id : String

## The Eventually Realm
## TODO make these also sharable so other players can utilize, as intended.
## player roles
## player abilities


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


func generate_id_hash(name_var : String):
	print("Creating ID With name_var: ", name_var)
	player_id = (name_var + Time.get_datetime_string_from_system()).md5_text()
	
