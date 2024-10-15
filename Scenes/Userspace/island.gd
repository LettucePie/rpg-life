extends Node3D
class_name Island
## 3D Visual host of PlayerData stations and decorations (IslandObjects)

signal island_selected(island)
signal island_released(island)

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
			print("Island Selected: ", self)
			emit_signal("island_selected", self)
		else:
			emit_signal("island_released", self)


func focus():
	print("Island Being Focused: ", self)
	if !is_connected("island_selected", PlayerInput.object_selected):
		connect("island_selected", PlayerInput.object_selected)
	if !is_connected("island_released", PlayerInput.object_released):
		connect("island_released", PlayerInput.object_released)
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
				io.connect_signals()


func unfocus():
	focused = false
	if is_connected("island_selected", PlayerInput.object_selected):
		disconnect("island_selected", PlayerInput.object_selected)
	if is_connected("island_released", PlayerInput.object_released):
		disconnect("island_released", PlayerInput.object_released)
	if objects.size() > 0:
		for io in objects:
			if io is IslandObject:
				io.disconnect_signals()


func translate_object(target_object : IslandObject, target_pos : Vector3):
	target_object.global_position = target_pos
