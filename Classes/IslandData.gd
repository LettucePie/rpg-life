extends Object
class_name IslandData


var island_name : String
var island_owner : PlayerData
var island_owner_id : String = ""
var island_node : Island
var io_data : Dictionary = {
	"object_names" : [],
	"positions" : [],
	"angles" : []
}


func assign_island_name(new_name : String):
	print("Assign Island Name: ", new_name)
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
		sanitized = "USER ISLAND"
	island_name = sanitized
	Persist.save_data()


func assign_island_owner(owner : PlayerData):
	print("Assign Island Owner: ", owner.player_name)
	island_owner = owner
	island_owner_id = owner.player_id


func update_data(island : Island):
	print("Convert Island: ", island, " to Savable/Sharable data.")
	
