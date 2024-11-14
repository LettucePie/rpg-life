extends Node3D


@export var window_size : Vector2i = Vector2i(512, 512)
@export var transparent : bool = true
@export var cap_name : String = "Icon"
@export_dir var cap_destination : String = "res://Assets/2D/UI/Object_Icons/"
@export var include_datetime : bool = false

func _ready():
	get_window().set_size(window_size)
	get_viewport().transparent_bg = transparent

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			print("Screenshot")
			var image = get_viewport().get_texture().get_image()
			var datetime = ""
			if include_datetime:
				datetime = "-" + str(Time.get_datetime_string_from_system())
			var file = cap_name + datetime + ".png"
			image.save_png(cap_destination + file)
