extends Node
class_name Play

@onready var menu : GalaxyMenu = $GalaxyMenu
@export var island_container : Node3D
@export var main_island : Island

var islands : Array[Island] = []
var focused_island : Island

# Called when the node enters the scene tree for the first time.
func _ready():
	if main_island != null:
		_gather_islands()
		_connect_islands()
		_island_selected(main_island)
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
		focused_island = target_island
		target_island.focus


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass