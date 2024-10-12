extends Control
class_name DecorateMenu

## Active Elements
var current_object : IslandObject
@onready var active_actions : Container = $ActiveHUD/ActiveVbox/ActiveActions
@onready var active_icon : TextureRect = $ActiveHUD/ActiveVbox/ActiveIcon
@onready var active_label : Label = $ActiveHUD/ActiveVbox/ActiveLabel

## Static Elements
@onready var back_button : BaseButton = $MarginContainer/BackButton

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


func set_active_object(object : IslandObject):
	_reset_active_elements()
	current_object = object
	current_object.outline(true)
	active_icon.texture.studio_capture_object(object)
	active_label.text = object.object_name
	active_actions.show()
	back_button.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	print("Exit Decorate")
	## Save/update island data


func _active_buttons(id : int):
	print("Active Object Button Pressed. ID: ", id)
	

