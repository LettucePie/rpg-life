extends Node
class_name IOCompendium

signal io_catalogued

var compendium : Array = []


class CompendiumEntry:
	var io_name : String = ""
	var io_scene_path : String = ""
	var scene_loaded : bool = false
	var loaded_scene : PackedScene = null


func _ready():
	## TODO replace with some form of caching
	rebuild_compendium_from_data()
	emit_signal("io_catalogued")


func rebuild_compendium_from_data():
	_dir_contents("res://Scenes/Userspace/Decoration/")


func _dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				_dir_contents(path + "/" + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.contains(".tscn"):
					_catalog_io_scene(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func _catalog_io_scene(path):
	var scene_file : FileAccess = FileAccess.open(path, FileAccess.READ)
	var content = scene_file.get_as_text()
	var content_lines = content.split("\n", false)
	for line in content_lines:
		if line.contains("object_name = "):
			var io_name : String = _rebuild_io_name(line.trim_prefix("object_name = "))
			if !_check_repeat_by_io_name(io_name):
				var new_entry : CompendiumEntry = CompendiumEntry.new()
				new_entry.io_name = io_name
				new_entry.io_scene_path = path
				compendium.append(new_entry)
	scene_file.close()


func _check_repeat_by_io_name(io_name : String) -> bool:
	var result : bool = false
	
	for entry in compendium:
		if entry.io_name == io_name:
			result = true
	
	return result


func _rebuild_io_name(io_name_raw : String) -> String:
	var result : String = ""
	
	var io_name_shaved : String = io_name_raw.trim_prefix("\"")
	io_name_shaved = io_name_shaved.trim_suffix("\"")
	for index in io_name_shaved.length():
		var char : String = io_name_shaved[index]
		if char != "\\":
			result += char
	
	return result


func load_entry_scene(entry : CompendiumEntry):
	if !entry.scene_loaded or entry.loaded_scene == null:
		entry.loaded_scene = load(entry.io_scene_path)
		entry.scene_loaded = true


func request_io_scene_by_name(req_name : String) -> PackedScene:
	var result = null
	
	for entry in compendium:
		if entry.io_name == req_name:
			if !entry.scene_loaded:
				load_entry_scene(entry)
			result = entry.loaded_scene
	
	if result == null:
		print("Failed to find requested io_scene by name of: ", req_name)
	return result


func request_io_scene_by_entry(req_entry : CompendiumEntry) -> PackedScene:
	var result = null
	
	if !req_entry.scene_loaded:
		load_entry_scene(req_entry)
	result = req_entry.loaded_scene
	
	if result == null:
		print("Failed to find requested io_scene by entry")
	return result
