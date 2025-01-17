extends Node
class_name Play
## Coordinates the interaction between 3D world events into 2D GUI events
## Also loads in PlayerData and connected Players PlayerData into the "Galaxy"

@onready var menu : GalaxyMenu = $GalaxyMenu
@onready var cam_dial : Node3D = $CameraDial
@onready var cam : Camera3D = get_viewport().get_camera_3d()
@export var island_container : Node3D
@export var main_island : Island

var islands : Array[Island] = []
var focused_island : Island
var camera_anchor : Vector3 = Vector3.ZERO
var camera_anchor_dir : Vector3 = Vector3.ZERO
var camera_anchor_rot : Vector3 = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	#initialize()
	pass


func initialize():
	PlayerInput._introduce_play(self)
	if main_island != null:
		_gather_islands()
		_connect_islands()
		_island_selected(main_island)
		if Persist.player_island_data == null:
			Persist.player_island_data = IslandData.new()
			Persist.player_island_data.island_node = main_island
			Persist.player_island_data.update_data(main_island)
			Persist.player_island_data.assign_island_owner(Persist.player_data)
			main_island.island_data = Persist.player_island_data
		else:
			main_island.assign_island_data(Persist.player_island_data)
	else:
		print("**ERROR** Main Island Missing! Game cannot continue.")


func _gather_islands():
	islands.clear()
	islands.append(main_island)
	if island_container != null:
		for child in island_container.get_children():
			if child is Island and !islands.has(child):
				islands.append(child)


func _connect_islands():
	for island in islands:
		if !island.island_selected.is_connected(_island_selected):
			island.island_selected.connect(_island_selected)


func _island_selected(target_island : Island):
	if !menu.menu_locked:
		if focused_island != target_island:
			if focused_island != null:
				focused_island.unfocus()
			focused_island = target_island
			target_island.focus()


func refocus_main_island():
	print("Refocusing Main Island")
	_island_selected(main_island)


func island_object_selected(object : IslandObject):
	print("Play Recieved Island Object: ", object.object_name)
	if menu.state == menu.MENU_STATES.DECORATE:
		if menu.decoration_menu.current_object != object:
			if !menu.decoration_menu.set_active_object(object) \
			and Persist.select_next_deco:
				menu.decoration_menu.quickset_active_object(object)


func set_cam_anchor(world_pos : Vector3):
	camera_anchor = world_pos
	camera_anchor_dir = cam_dial.basis * Vector3.FORWARD
	print("camera_anchor_dir: ", camera_anchor_dir)
	camera_anchor_rot = cam_dial.rotation


func manipulate_camera(world_pos : Vector3):
	var angle_a = camera_anchor_dir.signed_angle_to(camera_anchor, Vector3.UP)
	var angle_b = camera_anchor_dir.signed_angle_to(world_pos, Vector3.UP)
	cam_dial.rotation.y = camera_anchor_rot.y + (angle_a - angle_b)


#func spawn_island_object_into_island(island_object : IslandObject):
	#print("GalaxyPlay recieved request to place IslandObject: ", \
	#island_object.object_name, " from inventory onto the Island.")
	### TODO remove object from stored inventory into active inventory
	#_island_selected(main_island)
	#main_island.add_object(island_object)
	#menu.decoration_menu.set_active_object(island_object)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
