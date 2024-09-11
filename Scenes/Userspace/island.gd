extends Node3D
class_name Island

signal island_selected(island)

var focused : bool = false
@export var station_container : Node3D
var stations : Array[Station] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_island_area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index <= 1:
			emit_signal("island_selected", self)


func focus():
	stations.clear()
	if station_container != null:
		for child in station_container.get_children():
			if child is Station:
				stations.append(child)
	else:
		print("**ERROR** Cannot focus Stations of Island: ", self)


