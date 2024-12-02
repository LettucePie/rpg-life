extends Control
class_name DecorateMenu

signal exit_decorate()

## Constants
const ROTATE_SPEED : float = 0.045

## Active Elements
var current_object : IslandObject
@onready var active_actions : Control = $ActiveHUD
@onready var active_icon : TextureRect = $ActiveHUD/ActiveVbox/ActiveIcon
@onready var active_label : Label = $ActiveHUD/ActiveVbox/ActiveLabel
var grid_buttons : Array = []
@onready var deco_storage_grid : GridContainer = \
$Spawn_Toolset/Panel/List/GridPanel/GridScroll/GridContainer

## Static Elements
@onready var back_button : BaseButton = $Upper_Left_Action/BackButton
@onready var spawn_button : BaseButton = $Upper_Right_Action/SpawnButton
@onready var edit_tools : Control = $Edit_Toolset
@onready var spawn_tools : Control = $Spawn_Toolset
var grid_button_scene : PackedScene = preload("res://Scenes/GUI/grid_button.tscn")

## Tool States
var rotating : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	clean()
	_populate_deco_grid()


func clean():
	current_object = null
	_reset_active_elements()
	hide_all()


func _reset_active_elements():
	active_icon.texture.clear_object()
	active_label.text = ""


func hide_all():
	active_actions.hide()
	back_button.show()
	spawn_button.show()
	edit_tools.hide()
	spawn_tools.hide()


func set_active_object(object : IslandObject):
	_reset_active_elements()
	current_object = object
	current_object.outline(true)
	active_icon.texture.studio_capture_object(object)
	active_label.text = object.object_name
	active_actions.show()
	back_button.hide()
	spawn_button.hide()
	edit_tools.show()
	##
	PlayerInput.movement_locked = false


func unset_active_object():
	_reset_active_elements()
	if current_object != null:
		current_object.outline(false)
	current_object = null
	active_actions.hide()
	back_button.show()
	spawn_button.show()
	edit_tools.hide()
	##
	PlayerInput.movement_locked = true


func _populate_deco_grid():
	print("Populating DecoGrid")
	print("Currently filling with all, replace to Persist data")
	
	if grid_buttons.size() > 0:
		for gb in grid_buttons:
			gb.queue_free()
	grid_buttons.clear()
	
	for entry in IslandObjectCompendium.compendium:
		print(entry.io_name)
		var new_grid_button : GridButton = grid_button_scene.instantiate()
		new_grid_button.assign_island_object_entry(entry, 5)
		new_grid_button.adoption(deco_storage_grid)
		grid_buttons.append(new_grid_button)


func _process(delta):
	pass


func _on_back_button_pressed():
	print("Exit Decorate")
	emit_signal("exit_decorate")
	## Save/update island data


func _active_buttons(id : int):
	if id == 0:
		print("Remove Active Decoration")
	elif id == 1:
		print("Duplicate Active Decoration")
	elif id == 2:
		print("Finish Manipulating Active Decoration")
		unset_active_object()


func _on_rotate_zone_pressed():
	rotating = true
	print("Begin Rotating")
	##
	PlayerInput.movement_locked = true


func _on_spawn_button_pressed():
	if spawn_tools.visible:
		spawn_tools.hide()
	else:
		spawn_tools.show()


func _input(event):
	if rotating and event is InputEventMouseButton:
		if event.pressed == false:
			print("End Rotating")
			rotating = false
			##
			PlayerInput.movement_locked = false
	if rotating and event is InputEventMouseMotion:
		current_object.rotate_y((event.relative.x / PI) * ROTATE_SPEED)

