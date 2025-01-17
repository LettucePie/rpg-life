extends Node
class_name PlayerInputManager
## Handles Player inputs in 3D worldspace
## Menu navigation is independant

## Setup
var play : Play = null

## Constants
const ROTATE_SPEED : float = 0.045

## Dynamic
var selected_object : Node3D = null
var selected_object_pos_start : Vector3 = Vector3.ZERO
var camera_locked : bool = false
var camera_input_clone : Camera3D = null
var movement_locked : bool = true
var mouse_grab_pos_start : Vector2 = Vector2.ZERO
var mouse_grab_projection_start : Vector3 = Vector3.ZERO


func _introduce_play(in_play : Play):
	play = in_play


func object_selected(object : Node3D):
	print("InputManager Grabbed: ", object)
	selected_object = object
	selected_object_pos_start = object.position
	mouse_grab_pos_start = get_window().get_mouse_position()
	mouse_grab_projection_start = plane_projection(
			mouse_grab_pos_start, play.cam
	)
	if object is IslandObject:
		play.island_object_selected(object)
	if object is Island and !camera_locked:
		_conjure_input_camera(play.cam)
		play.set_cam_anchor(
				plane_projection(
						get_window().get_mouse_position(), camera_input_clone
				)
		)


func object_released(object : Node3D):
	print("InputManager Released: ", object)
	selected_object = null


func object_dragged(object : Node3D, event : InputEvent):
	print("InputManager Dragging: ", object)
	if play.menu.state == GalaxyMenu.MENU_STATES.DECORATE:
		if selected_object.outlined:
			var world_pos : Vector3 = plane_projection(
					event.global_position, play.cam
			)
			## TODO diagnose the snap to position difference
			## maybe calculate off a start plane_projection
			print("INP: ", event.global_position - mouse_grab_pos_start)
			print("POS: ", world_pos - selected_object_pos_start)
			print("ADJ: ", world_pos - mouse_grab_projection_start)
			var offset : Vector3 = (world_pos - mouse_grab_projection_start) \
					+ selected_object_pos_start
			play.focused_island.translate_object(
					selected_object, offset
			)


func object_rotated(object : Node3D, event : InputEvent):
	print("InputManager Rotating: ", object)
	if play.menu.state == GalaxyMenu.MENU_STATES.DECORATE:
		if selected_object.outlined:
			play.focused_island.rotate_object(
					selected_object, (event.relative.x / PI) * ROTATE_SPEED
			)


func _input(event):
	if event is InputEventMouseButton:
		if !event.pressed:
			if selected_object is IslandObject:
				selected_object.held = false
			elif selected_object is Island:
				if is_instance_valid(camera_input_clone):
					camera_input_clone.queue_free()
				camera_input_clone = null
			selected_object = null
	if event is InputEventMouseMotion and selected_object != null:
		if selected_object is Island and !camera_locked:
			#play.manipulate_camera(event.relative)
			play.manipulate_camera(
					plane_projection(
							event.global_position, camera_input_clone
					)
			)
		if selected_object is IslandObject and !movement_locked:
			if play.menu.decoration_menu.rotating:
				object_rotated(selected_object, event)
			else:
				object_dragged(selected_object, event)


func _conjure_input_camera(target_cam : Camera3D):
	camera_input_clone = Camera3D.new()
	camera_input_clone.global_transform = target_cam.global_transform
	add_child(camera_input_clone)


## Nice Answer Theraot
## https://gamedev.stackexchange.com/questions/194616/
func plane_projection(mouse_pos : Vector2, cam : Camera3D):
	var result : Vector3 = Vector3.ZERO
	##
	var origin : Vector3 = cam.project_ray_origin(mouse_pos)
	var normal : Vector3 = cam.project_ray_normal(mouse_pos)
	var distance : float = play.focused_island.global_position.distance_to(
			cam.global_position
	)
	if normal.y != 0:
		distance = -origin.y / normal.y
	result = origin + normal * distance
	##
	return result
