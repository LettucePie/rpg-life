extends Node3D


@onready var point = $Point

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_platform_input_event(camera, event, pos, normal, shape_idx):
	if event is InputEventMouse:
		point.set_position(pos)
	if event is InputEventMouseButton:
		if event.pressed:
			print(shape_idx)
