extends StaticBody3D
class_name Station

signal station_selected(station)

var default_station_shape : PackedScene = preload(
	"res://Scenes/Userspace/Stations/default_station_shape.tscn"
	)


@export var station_name : String


func _ready():
	if !_check_shape():
		print("**ERROR**")
		print("Station Missing Shape: ", station_name, " | ", self.name)
		add_child(default_station_shape.instantiate())
	_connect_signals()


func _check_shape() -> bool:
	var result := false
	for child in get_children():
		if child is CollisionPolygon3D or child is CollisionShape3D:
			result = true
	return result


func _connect_signals():
	if !is_connected("input_event", _on_input_event):
		input_event.connect(_on_input_event)


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index <= 1:
			print("Station Pressed: ", station_name)
			emit_signal("station_selected", self)
