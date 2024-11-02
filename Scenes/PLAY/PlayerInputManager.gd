extends Node
class_name PlayerInputManager
## Handles Player inputs in 3D worldspace
## Menu navigation is independant

## Setup
var play : Play = null

## Dynamic
var selected_object : Node3D = null
var camera_locked : bool = false
var movement_locked : bool = true


func _introduce_play(in_play : Play):
	play = in_play


func object_selected(object : Node3D):
	print("InputManager Grabbed: ", object)
	selected_object = object
	if object is IslandObject:
		play.island_object_selected(object)
	if object is Island and !camera_locked:
		play.set_cam_anchor(plane_projection(get_window().get_mouse_position(), play.cam))


func object_released(object : Node3D):
	print("InputManager Released: ", object)
	selected_object = null


func _input(event):
	if event is InputEventMouseButton:
		if !event.pressed and selected_object != null:
			if selected_object is IslandObject:
				selected_object.held = false
			selected_object = null
	if event is InputEventMouseMotion and selected_object != null:
		if selected_object is Island and !camera_locked:
			#play.manipulate_camera(event.relative)
			play.manipulate_camera(plane_projection(event.global_position, play.cam))
		if selected_object is IslandObject and !movement_locked:
			var world_pos : Vector3 = plane_projection(event.global_position, play.cam)
			play.focused_island.translate_object(selected_object, world_pos)


## Nice Answer Theraot
## https://gamedev.stackexchange.com/questions/194616/
func plane_projection(mouse_pos : Vector2, cam : Camera3D):
	var result : Vector3 = Vector3.ZERO
	##
	var origin : Vector3 = cam.project_ray_origin(mouse_pos)
	var normal : Vector3 = cam.project_ray_normal(mouse_pos)
	var distance : float = play.focused_island.global_position.distance_to(cam.global_position)
	if normal.y != 0:
		distance = -origin.y / normal.y
	result = origin + normal * distance
	##
	return result
