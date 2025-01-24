extends Button
class_name GridButton
enum BUTTON_TYPE {island_object, resource}
signal grid_button_pressed(button)

var default_icon : Texture2D = preload("res://icon.svg")

## Dynamic
var button_type : BUTTON_TYPE
var data_ref = null


func _ready():
	if !is_connected("pressed", _button_pressed):
		pressed.connect(_button_pressed)


func assign_island_object_data(data : IO_Data, quantity : int):
	##
	
	button_type = BUTTON_TYPE.island_object
	data_ref = [data, quantity]
	if data.io_icon != null:
		icon = data.io_icon
	else:
		icon = default_icon
	text = data.io_name + "\nx" + str(quantity)


func update_button_text():
	if button_type == BUTTON_TYPE.island_object \
	and data_ref[0] is IO_Data:
		text = data_ref[0].io_name + "\nx" + str(data_ref[1])


func adoption(parent : GridContainer):
	parent.add_child(self)
	parent.resized.connect(_adjust_size)
	_adjust_size()


func _adjust_size():
	var parent : GridContainer = get_parent()
	var h = parent.get_size().y
	custom_minimum_size.y = int(h / parent.columns)


func _button_pressed():
	print("Button Pressed")
	emit_signal("grid_button_pressed", self)

