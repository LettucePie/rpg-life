extends StaticBody3D
class_name IslandObject
## Parent Class
## Every object that can be seen on a Players Island.
## Stations, Decorations, and more to be made?

signal object_selected(object)
signal object_released(object)

## Settings
@export var object_name : String
@export var object_icon : Texture

## Assets
var default_object_shape : PackedScene = preload(
	"res://Scenes/Userspace/default_station_shape.tscn"
	)
var outline_material : ShaderMaterial = preload(
	"res://Assets/3D/Materials/FX/outline_shader_mat.tres"
)

## Visual
var children_geometry : Array = []
var outlined : bool = false


## Input States
var held : bool = false


func _ready():
	initialize()


func initialize():
	if !_check_shape():
		print("**ERROR**")
		print("Object Missing Shape: ", object_name, " | ", self.name)
		add_child(default_object_shape.instantiate())
	connect_signals()
	_groupify()
	_find_geometries()
	print(object_name, " children_geo: ", children_geometry.size())


func _check_shape() -> bool:
	var result := false
	for child in get_children():
		if child is CollisionPolygon3D or child is CollisionShape3D:
			result = true
	return result


func connect_signals():
	if !is_connected("input_event", _on_input_event):
		input_event.connect(_on_input_event)
	if !is_connected("object_selected", PlayerInput.object_selected):
		connect("object_selected", PlayerInput.object_selected)
	if !is_connected("object_released", PlayerInput.object_released):
		connect("object_released", PlayerInput.object_released)


func disconnect_signals():
	if is_connected("object_selected", PlayerInput.object_selected):
		disconnect("object_selected", PlayerInput.object_selected)
	if is_connected("object_released", PlayerInput.object_released):
		disconnect("object_released", PlayerInput.object_released)


func _groupify():
	if !is_in_group("IslandObject"):
		add_to_group("IslandObject")


func _find_geometries():
	var pile = []
	var array = get_children()
	_iterate(array, pile)
	for node in pile:
		if node is GeometryInstance3D:
			children_geometry.append(node)


func _iterate(array, pile):
	for a in array:
		_gather(a, pile)
		_ponder(a, pile)


func _gather(a, pile):
	if !pile.has(a):
		pile.append(a)


func _ponder(a, pile):
	if a.get_child_count() > 0:
		_iterate(a.get_children(), pile)


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index <= 1:
			print("Object Pressed: ", object_name)
			held = true
			emit_signal("object_selected", self)
		else:
			held = false
			emit_signal("object_released", self)


func outline(tf : bool):
	outlined = tf
	if tf:
		for geo in children_geometry:
			geo.set_material_overlay(outline_material)
	else:
		for geo in children_geometry:
			geo.set_material_overlay(null)
