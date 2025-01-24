extends EditorInspectorPlugin

signal pack_me(b)

var box : Box
var parser_control = preload("res://addons/packer/box_parser_control.gd")

func _can_handle(object):
	if object is Box:
		box = object
		return true


func _parse_category(object, category):
	if category == "box.gd":
		var p_con = parser_control.new()
		p_con.pack_me.connect(self._button_pack_me)
		box.io_catalogued.connect(p_con.done_packing)
		add_custom_control(p_con)


func _button_pack_me():
	emit_signal("pack_me", box)
