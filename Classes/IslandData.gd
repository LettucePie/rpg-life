extends Object
class_name IslandData


var island_name : String
var island_owner_id : String
var island_node : Island


func island_to_data(island : Island):
	print("Convert Island: ", island, " to Savable/Sharable data.")
