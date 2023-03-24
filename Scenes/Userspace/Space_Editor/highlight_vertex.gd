extends Node3D


@onready var point = $Point
@onready var mesh_rend = $Platform/Mesh
var mesh : Mesh
var mesh_verts : PackedVector3Array
var vert_positions : PackedVector3Array

# Called when the node enters the scene tree for the first time.
func _ready():
	_gather_verts()


###
### Gather Mesh and Vertices Array
func _gather_verts():
	mesh = mesh_rend.get_mesh()
	var mesh_array = mesh.surface_get_arrays(0)
	mesh_verts = mesh_array.front()
	###
	### To clear out any duplicates and focus on positioning
	var center = $Platform.get_position()
	vert_positions.clear()
	for vert in mesh_verts:
		if !vert_positions.has(vert + center):
			vert_positions.append(vert + center)

###
### Return the Nearest Point to the given Vector from the array of \
### Vertex Positions
func _return_nearest_point(p : Vector3) -> Vector3:
	var result = Vector3.ZERO
	var smallest_distance = 200
	for v in vert_positions:
		var distance = v.distance_squared_to(p)
		if distance < smallest_distance:
			smallest_distance = distance
			result = v
	return result


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_platform_input_event(camera, event, pos, normal, shape_idx):
	if event is InputEventMouse:
		point.set_position(_return_nearest_point(pos))
	if event is InputEventMouseButton:
		if event.pressed:
			print(shape_idx)
