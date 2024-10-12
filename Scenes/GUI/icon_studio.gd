extends SubViewport
class_name IconStudio

var subject : IslandObject = null
var rotate : bool = false
var studiotex : StudioTexture = null
var host_node : Control = null


func assign_subject(object : IslandObject):
	if subject != null:
		subject.queue_free()
	subject = object
	add_child(subject)
	subject.outline(false)


func clear_subject():
	if subject != null:
		subject.queue_free()


func set_camera(spin : bool, initial_angle : float):
	subject.rotation.y = initial_angle
	rotate = spin


func associate_nodes(display : StudioTexture, node : Control):
	studiotex = display
	host_node = node


func _process(delta):
	if rotate:
		$Spin.rotate_y((PI / 8) * delta)
	if studiotex != null:
		if studiotex.get_reference_count() <= 1:
			self.queue_free()
