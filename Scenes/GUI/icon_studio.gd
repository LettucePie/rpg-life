extends SubViewport
class_name IconStudio

var subject : IslandObject = null
var rotate : bool = false
var studiotex : StudioTexture = null


func prep_studio(object : IslandObject, 
spin : bool, initial_angle : float, display : StudioTexture):
	if subject != null:
		subject.queue_free()
	subject = object
	add_child(subject)
	subject.outline(false)
	subject.rotation.y = initial_angle
	rotate = spin
	studiotex = display


func clear_subject():
	if subject != null:
		subject.queue_free()


func _process(delta):
	if rotate:
		$Spin.rotate_y((PI / 8) * delta)
	if studiotex != null:
		print("studio_tex refcount: ", studiotex.get_reference_count())
