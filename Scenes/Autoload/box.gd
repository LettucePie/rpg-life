@tool
extends Node
class_name Box
## This is TheBox. It's objective is to handle the resource loading.

enum PARSE_TARGET {IO, MAT, EQP}

## Import
@export_dir var io_dir : String
@export_dir var m : String
#@export var io_list : Array[PackedScene]

## Catalogued
@export var res_catalog : Array[PlayerResource]
@export var io_catalog : Array[IO_Data]
@export var mat_catalog : Array[MaterialData]
signal io_catalogued
signal mat_catalogued

var icon_regex : RegEx

func _ready():
	icon_regex = RegEx.new()
	icon_regex.compile("path=\"(\\S*)\"")


func catalog_all(save_local : bool):
	print("THE BOX CATALOGS ALL!!!")
	rebuild_io_catalog()
	if save_local and Engine.is_editor_hint():
		print("Saving generated metadata resources.")
		var io_path_start : String = "res://Data/IO_Data/"
		for io_dat in io_catalog:
			io_dat.take_over_path(io_path_start + io_dat.res_name + ".tres")
			ResourceSaver.save(io_dat)
		var file_count = DirAccess.get_files_at(io_path_start).size()
		if file_count > io_catalog.size():
			print("PACKING NOTICE! : more IO_Data files in filesystem than the box.")
		elif file_count < io_catalog.size():
			print("PACKING ERROR! : there are less IO_DATA files in filesystem than box")
		elif file_count == io_catalog.size():
			print("IO_Data is saved, no issues of note.")


func rebuild_io_catalog():
	io_catalog.clear()
	_dir_contents(io_dir, PARSE_TARGET.IO)
	emit_signal("io_catalogued")


func rebuild_mat_catalog():
	mat_catalog.clear()
	## or just parse the csv file if there is only one?
	#_dir_contents(mat_icon_dir, PARSE_TARGET.MAT)
	emit_signal("mat_catalogued")


func _dir_contents(path, target : PARSE_TARGET):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				_dir_contents(path + "/" + file_name, target)
			else:
				if file_name.contains(".tscn"):
					if target == PARSE_TARGET.IO:
						_catalog_io_scene(path + "/" + file_name)
				elif file_name.contains(".csv"):
					pass
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func _catalog_io_scene(path):
	var scene_file : FileAccess = FileAccess.open(path, FileAccess.READ)
	var content = scene_file.get_as_text()
	var content_lines = content.split("\n", false)
	var new_data : IO_Data = IO_Data.new()
	new_data.io_scene = load(path)
	for line in content_lines:
		if line.contains("object_name = "):
			var io_name : String = _rebuild_io_name(line.trim_prefix(
				"object_name = "
				))
			if !_check_repeat_by_io_name(io_name):
				new_data.res_name = io_name
				new_data.io_scene_path = path
		if line.contains("object_icon = "):
			var icon_ext_id : String = line.trim_prefix(
				"object_icon = ExtResource("
				)
			icon_ext_id = icon_ext_id.trim_suffix(")")
			for subline in content_lines:
				if subline.contains("id=" + icon_ext_id) \
				and subline.contains("type=\"Texture2D\""):
					print("Found ExternalResource Icon, ", icon_ext_id, \
						" : ", new_data.res_name)
					var regex_result = icon_regex.search(subline)
					if regex_result \
					and regex_result.get_string(1).is_absolute_path():
						new_data.io_icon = load(regex_result.get_string(1))
	if new_data.res_name != "":
		io_catalog.append(new_data)
	scene_file.close()

## Will I have multiple csv files?
func parse_materials_csv():
	pass


func _check_repeat_by_io_name(io_name : String) -> bool:
	var result : bool = false
	
	for data in io_catalog:
		if data.res_name == io_name:
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


func request_io_scene_by_name(req_name : String) -> PackedScene:
	var result = null
	
	for data in io_catalog:
		if data.res_name == req_name:
			result = data.io_scene
	
	if result == null:
		print("Failed to find requested io_scene by name of: ", req_name)
	return result


func request_io_data_by_name(req_name : String) -> IO_Data:
	var result : IO_Data = null
	
	for data in io_catalog:
		if data.res_name == req_name:
			result = data
	
	return result
