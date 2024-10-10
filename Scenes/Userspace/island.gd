extends Node3D
class_name Island

signal island_selected(island)
signal object_selected(object)

var focused : bool = false
@export var object_container : Node3D
var objects : Array[IslandObject] = []
var stations : Array[Station] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_island_area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index <= 1:
			emit_signal("island_selected", self)


func focus():
	print("Island Being Focused: ", self)
	objects.clear()
	stations.clear()
	if object_container != null:
		for child in object_container.get_children():
			if child is IslandObject:
				objects.append(child)
			if child is Station:
				stations.append(child)
	else:
		print("**ERROR** Cannot focus Objects of Island: ", self)
	focused = true
	_connect_objects()


func _connect_objects():
	if objects.size() > 0:
		for io in objects:
			if io is IslandObject:
				if !io.object_selected.is_connected(_object_selected):
					io.object_selected.connect(_object_selected)


func _object_selected(object : IslandObject):
	if focused:
		print("Island Recieved object selection: ", object.object_name)
		emit_signal("object_selected", object)
