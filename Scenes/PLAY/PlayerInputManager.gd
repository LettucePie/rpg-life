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


func object_released(object : Node3D):
	print("InputManager Released: ", object)
	selected_object = null


func _input(event):
	if event is InputEventMouseMotion and selected_object != null:
		if selected_object is Island and !camera_locked:
			play.manipulate_camera(event.relative)
		if selected_object is IslandObject and !movement_locked:
			play.focused_island.translate_object(
				selected_object, event.relative, play.cam_dial
			)

