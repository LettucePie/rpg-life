extends Button
class_name GridButton
enum BUTTON_TYPE {island_object, resource}

## Dynamic
var button_type : BUTTON_TYPE
var data_ref = null


func _ready():
	if !is_connected("pressed", _button_pressed):
		pressed.connect(_button_pressed)


func assign_island_object_entry(entry : IOCompendium.CompendiumEntry, quantity : int):
	button_type = BUTTON_TYPE.island_object
	data_ref = [IslandObjectCompendium.request_io_scene_by_entry(entry), quantity]
	icon.studio_capture_object(data_ref[0])
	text = entry.io_name + "\nx" + str(quantity)


func _button_pressed():
	print("Button Pressed")
