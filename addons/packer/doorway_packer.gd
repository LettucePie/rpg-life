extends EditorExportPlugin

signal pack_me(b)
var box = preload("res://Scenes/Autoload/box.tscn")

func _export_begin(features, is_debug, path, flags):
	print("EXPORTING DETECTED... PACK THAT BOX!")
	emit_signal("pack_me", box)
