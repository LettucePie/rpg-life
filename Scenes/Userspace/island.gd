extends Node3D
class_name Island
## 3D Visual host of PlayerData stations and decorations (IslandObjects)

signal island_selected(island)
signal island_released(island)

var focused : bool = false
@export var object_container : Node3D
var objects : Array[IslandObject] = []
var stations : Array[Station] = []

var awaiting_suspended_object : bool = false
var suspended_island_object : IslandObject
## For reasons I don't entirely understand, I decided to, for the first time
## in my entire life, assign a callable method dynamically.
var deco_menu_callable : Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_island_area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index <= 1:
			print("Island Selected: ", self)
			emit_signal("island_selected", self)
			if awaiting_suspended_object:
				add_object(suspended_island_object, position)
				deco_menu_callable.call(true)
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


func add_object(island_object : IslandObject, at_pos : Vector3):
	print("Adding IslandObject: ", island_object, " to Island: ", self)
	object_container.add_child(island_object)
	objects.append(island_object)
	island_object.position = at_pos
	if island_object is Station:
		stations.append(island_object)
	_connect_objects()


func remove_object(island_object : IslandObject):
	print("Removing IslandObject: ", island_object)
	if objects.has(island_object):
		objects.erase(island_object)
	if island_object is Station and stations.has(island_object):
		stations.erase(island_object)
	if is_instance_valid(island_object):
		island_object.queue_free()
	_connect_objects()


func setup_suspended_island_object(suspended_object : IslandObject, return_address : Callable):
	awaiting_suspended_object = true
	suspended_island_object = suspended_object
	deco_menu_callable = return_address


func cancel_suspended_island_object():
	awaiting_suspended_object = false
	suspended_island_object = null
