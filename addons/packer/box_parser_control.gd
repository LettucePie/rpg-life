extends EditorProperty

signal pack_me
var prop_control = Button.new()

func _init():
	add_child(prop_control)
	prop_control.text = "PACK ME"
	prop_control.pressed.connect(self._pressed)

func _pressed():
	emit_signal("pack_me")
