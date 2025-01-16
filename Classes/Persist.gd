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
var player_data : PlayerData
var inventory : Array[ItemEntry] = []
var player_island_data : IslandData

## Player Settings
var select_next_deco : bool = false
 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


## Loads data from File
func load_data():
	print("Loading")
	VPrint.vprint("Loading PersistData")
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
	VPrint.vprint("Glossarizing Inventory")
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
					VPrint.vprint("Error Glossarizing Inventory")
			if item.types.has(ItemEntry.ITEMTYPE.EQUIPMENT):
				pass


## Creates a template for testing
func template_data():
	print("**DEBUG** Creating Testing Data")
	VPrint.vprint("Creating Testing PersistData")
	var tree_entry : ItemEntry = ItemEntry.new()
	tree_entry.quantity = 5
	tree_entry.item_name = "Pine Tree A"
	tree_entry.types = [1]
	inventory.append(tree_entry)
	var bush_entry : ItemEntry = ItemEntry.new()
	bush_entry.quantity = 5
	bush_entry.item_name = "Bush A"
	bush_entry.types = [1]
	inventory.append(bush_entry)
	print("**DEBUG** Creating playerdata.")
	player_data = PlayerData.new()
	player_data.assign_name("Matthew")
	player_data.generate_id_hash(player_data.player_name)
	print("PlayerData player_id: ", player_data.player_id)


func update_quantity_by_item_entry(target : ItemEntry, variable : int):
	if inventory.has(target):
		target.quantity += variable
		_validate_quantity(target)
		save_data()


func update_quantity_by_item_name_type(
	tar_name : String, tar_type : ItemEntry.ITEMTYPE, variable : int):
	##
	var valid : bool = false
	for item in inventory:
		if item.types.has(tar_type) and item.item_name == tar_name:
			item.quantity += variable
			valid = true
			_validate_quantity(item)
	if valid:
		save_data()


func _validate_quantity(target : ItemEntry):
	if target.quantity <= 0:
		inventory.erase(target)


func add_inventory_by_name_type(
		tar_name : String, tar_types : Array[ItemEntry.ITEMTYPE], amount : int):
	##
	print("Adding to Persist Inventory a ", tar_name, " by ", amount)
	print("**TODO** scry through Compendiums to validate/retrieve item types.")
	print("Current Situation allows exception where a Material + Object will \
	get placed onto the Island, then when removed be converted to Object only.")
	if get_quantity_by_item_name_type(tar_name, tar_types[0]) <= 0:
		var new_inventory_entry : ItemEntry = ItemEntry.new()
		new_inventory_entry.quantity = amount
		new_inventory_entry.item_name = tar_name
		new_inventory_entry.types = tar_types
		inventory.append(new_inventory_entry)
		save_data()
	else:
		print("Inventory already has ItemEntry for ", tar_name)


func get_quantity_by_item_entry(target : ItemEntry) -> int:
	var result : int = 0
	
	if inventory.has(target):
		result = target.quantity
	
	return result


func get_quantity_by_item_name_type(
	tar_name : String, tar_type : ItemEntry.ITEMTYPE) -> int:
	##
	var result : int = 0
	
	for item in inventory:
		if item.item_name == tar_name and item.types.has(tar_type):
			result = item.quantity
	
	return result

