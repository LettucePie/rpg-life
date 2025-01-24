@tool
extends EditorPlugin
## This is the Box Packer. It's objective is to provide tooling for packing
## TheBox

var box_parser
var doorway_packer

func _enter_tree():
	box_parser = preload("res://addons/packer/box_parser.gd").new()
	box_parser.pack_me.connect(self._packing_time)
	add_inspector_plugin(box_parser)
	doorway_packer = preload("res://addons/packer/doorway_packer.gd").new()
	doorway_packer.pack_me.connect(self._packing_time)
	add_export_plugin(doorway_packer)


func _exit_tree():
	remove_inspector_plugin(box_parser)
	remove_export_plugin(doorway_packer)


func _packing_time(box : Box):
	print("IT'S PACKING TIME!!! ", box)
	box.catalog_all()
