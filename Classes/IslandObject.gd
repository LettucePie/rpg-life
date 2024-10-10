extends StaticBody3D
class_name IslandObject

signal object_selected(object)

var default_object_shape : PackedScene = preload(
	"res://Scenes/Userspace/Stations/default_station_shape.tscn"
	)


@export var object_name : String


func _ready():
	if !_check_shape():
		print("**ERROR**")
		print("Object Missing Shape: ", object_name, " | ", self.name)
		add_child(default_object_shape.instantiate())
	_connect_signals()
	_groupify()


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


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index <= 1:
			print("Object Pressed: ", object_name)
			emit_signal("object_selected", self)
