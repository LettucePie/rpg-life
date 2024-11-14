extends Button
class_name GridButton
enum BUTTON_TYPE {island_object, resource}

var default_icon : Texture2D = preload("res://icon.svg")

## Dynamic
var button_type : BUTTON_TYPE
var data_ref = null


func _ready():
	if !is_connected("pressed", _button_pressed):
		pressed.connect(_button_pressed)


func assign_island_object_entry(entry : IOCompendium.CompendiumEntry, quantity : int):
	button_type = BUTTON_TYPE.island_object
	data_ref = [entry, quantity]
	if entry.io_icon != null:
		icon = entry.io_icon
	else:
		icon = default_icon
	text = entry.io_name + "\nx" + str(quantity)


func adoption(parent : GridContainer):
	parent.add_child(self)
	parent.resized.connect(_adjust_size)


func _adjust_size():
	var parent : GridContainer = get_parent()
	var h = parent.get_size().y
	custom_minimum_size.y = int(h / parent.columns)


func _button_pressed():
	print("Button Pressed")
