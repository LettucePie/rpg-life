extends ViewportTexture
class_name StudioTexture

var studio_scene : PackedScene = preload("res://Scenes/GUI/icon_studio.tscn")
var studio_node : IconStudio = null

@export_range(0.0, PI, 0.1) var starting_angle : float = PI / 8
@export var rotate_cam : bool = false


func studio_capture_object(object : IslandObject):
	if studio_node == null:
		var new_studio = studio_scene.instantiate()
		get_local_scene().get_window().add_child(new_studio)
		studio_node = new_studio
	studio_node.assign_subject(object.duplicate())
	studio_node.set_camera(rotate_cam, starting_angle)
	studio_node.associate_nodes(self, get_local_scene())
	set_viewport_path_in_scene(studio_node.get_path())


func clear_object():
	if studio_node != null:
		studio_node.clear_subject()
