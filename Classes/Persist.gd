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
	
	## Filters compendium_entries for typeof entry.
	func return_entry_of_type(type : ITEMTYPE):
		if glossarized and types.has(type):
			for entry in compendium_entries:
				if type == ITEMTYPE.MATERIAL \
				and entry is MaterialCompendium.CompendiumEntry:
					return entry
				if type == ITEMTYPE.OBJECT \
				and entry is IslandObjectCompendium.CompendiumEntry:
					return entry
				if type == ITEMTYPE.EQUIPMENT \
				and entry is EquipmentCompendium.CompendiumEntry:
					return entry
		else:
			return null


## Player Data
var inventory : Array[ItemEntry] = []

## Player Settings

 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


## Loads data from File
func load_data():
	print("Loading")
	if FileAccess.file_exists("user://savegame.save"):
		var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		print("Save File Opened")
	else:
		print("Save File Missing")
		## Setting up test file.
		template_data()
		_glossarize_inventory()
		emit_signal("finished_loading")


## Saves data to File
func save_data():
	print("Saving")


## Connects items in inventory to their Compendium (Database) entries
func _glossarize_inventory():
	print("Connecting loaded inventory entries to corresponding compendiums.")
	for item in inventory:
		if !item.glossarized:
			if item.types.has(ItemEntry.ITEMTYPE.MATERIAL):
				pass
			if item.types.has(ItemEntry.ITEMTYPE.OBJECT):
				var compendium_entry : IslandObjectCompendium.CompendiumEntry
				compendium_entry = IslandObjectCompendium \
						.request_compendium_entry_by_name(item.item_name)
				if compendium_entry != null:
					item.compendium_entries.append(compendium_entry)
					item.glossarized = true
				else:
					print("**ERROR** Glossarizing Inventory Failed!")
					print("ITEMTYPE.OBJECT | ", item.item_name, " MISSING")
			if item.types.has(ItemEntry.ITEMTYPE.EQUIPMENT):
				pass


## Creates a template for testing
func template_data():
	print("**DEBUG** Creating Testing Data")
	var tree_entry : ItemEntry = ItemEntry.new()
	tree_entry.quantity = 5
	tree_entry.item_name = "Pine Tree A"
	tree_entry.types = [1]
	inventory.append(tree_entry)


