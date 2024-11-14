extends Button

var assigned_object : IslandObject = null
var assigned_quantity : int = -1

func _ready():
	if !is_connected("pressed", _button_pressed):
		pressed.connect(_button_pressed)


func assign_island_object(io : IslandObject, quantity : int):
	print("Assigning IslandObject: ", io, " to GridButton")


func _button_pressed():
	print("Button Pressed")
