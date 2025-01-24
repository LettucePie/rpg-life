@tool
extends EditorPlugin
## This is the Box Packer. It's objective is to provide tooling for packing
## TheBox

var box_parser

func _enter_tree():
	box_parser = preload("res://addons/packer/box_parser.gd").new()
	box_parser.pack_me.connect(self._packing_time)
	add_inspector_plugin(box_parser)


func _exit_tree():
	remove_inspector_plugin(box_parser)


func _packing_time(box : Box):
	print("IT'S PACKING TIME!!! ", box)
