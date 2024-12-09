extends Node
class_name PersistData
## Save File System

signal finished_loading()

class ItemEntry:
	## Metatable class for structuring player inventory.
	
	## Saveable Data
	var quantity : int = 0
	var item_name : String
	enum ITEMTYPE {MATERIAL, OBJECT, EQUIPMENT}
	var types : Array[ITEMTYPE] = []
	## Connected Data
	var glossarized : bool = false
	var compendium_entries : Array = []


## Player Data
var inventory : Array[ItemEntry] = []

## Player Settings

 

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()


## Loads data from File
func load_data():
	print("Loading")
	if FileAccess.file_exists("user://savegame.save"):
		var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		print("Save File Opened")
	else:
		print("Save File Missing")


## Saves data to File
func save_data():
	print("Saving")


## Connects items in inventory to their Compendium (Database) entries
func _glossarize_inventory():
	print("Connecting loaded inventory entries to corresponding compendiums.")
