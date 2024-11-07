extends Control
class_name DecorateMenu

signal exit_decorate()

## Constants
const ROTATE_SPEED : float = 0.045

## Active Elements
var current_object : IslandObject
@onready var active_actions : Container = $ActiveHUD/ActiveVbox/ActiveActions
@onready var active_icon : TextureRect = $ActiveHUD/ActiveVbox/ActiveIcon
@onready var active_label : Label = $ActiveHUD/ActiveVbox/ActiveLabel

## Static Elements
@onready var back_button : BaseButton = $MarginContainer/BackButton
@onready var edit_tools : Control = $Edit_Toolset
@onready var spawn_tools : Control = $Spawn_Toolset

## Tool States
var rotating : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	clean()


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
	edit_tools.hide()
	##
	PlayerInput.movement_locked = true


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


func _input(event):
	if rotating and event is InputEventMouseButton:
		if event.pressed == false:
			print("End Rotating")
			rotating = false
			##
			PlayerInput.movement_locked = false
	if rotating and event is InputEventMouseMotion:
		current_object.rotate_y((event.relative.x / PI) * ROTATE_SPEED)
