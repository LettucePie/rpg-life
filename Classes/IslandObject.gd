extends StaticBody3D
class_name IslandObject

signal object_selected(object)

var default_object_shape : PackedScene = preload(
	"res://Scenes/Userspace/Stations/default_station_shape.tscn"
	)
var outline_material : ShaderMaterial = preload(
	"res://Assets/3D/Materials/FX/outline_shader_mat.tres"
)

var children_geometry : Array = []
var outlined : bool = false

@export var object_name : String


func _ready():
	initialize()


func initialize():
	if !_check_shape():
		print("**ERROR**")
		print("Object Missing Shape: ", object_name, " | ", self.name)
		add_child(default_object_shape.instantiate())
	_connect_signals()
	_groupify()
	_find_geometries()


func _check_shape() -> bool:
	var result := false
	for child in get_children():
		if child is CollisionPolygon3D or child is CollisionShape3D:
			result = true
	return result


func _connect_signals():
	if !is_connected("input_event", _on_input_event):
		input_event.connect(_on_input_event)


func _groupify():
	if !is_in_group("IslandObject"):
		add_to_group("IslandObject")


func _find_geometries():
	print("Finding Meshes/GeometryInstances")
	var pile = []
	var array = get_children()
	_iterate(array, pile)
	for node in pile:
		print(node)
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
			emit_signal("object_selected", self)


func outline(tf : bool):
	if tf:
		for geo in children_geometry:
			geo.set_material_overlay(outline_material)
	else:
		for geo in children_geometry:
			geo.set_material_overlay(null)
