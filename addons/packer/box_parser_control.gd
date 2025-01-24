extends EditorProperty

signal pack_me
var prop_control = Button.new()
var updating = false


func _init():
	add_child(prop_control)
	prop_control.text = "PACK ME"
	prop_control.pressed.connect(self._pressed)


func _pressed():
	if (updating):
		return
	emit_signal("pack_me")
	updating = true
	prop_control.text = "PACKING..."


func done_packing():
	print("DONE PACKING!")
	updating = false
	prop_control.text = "PACK ME"
