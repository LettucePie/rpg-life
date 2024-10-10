extends Control
class_name DecorateMenu

## Active Elements
var current_object : IslandObject
@onready var active_actions : Container = $ActiveHUD/ActiveVbox/ActiveActions
@onready var active_icon : TextureRect = $ActiveHUD/ActiveVbox/ActiveIcon
@onready var active_label : Label = $ActiveHUD/ActiveVbox/ActiveLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	clean()


func clean():
	current_object = null
	_reset_active_elements()
	hide_all()


func _reset_active_elements():
	active_icon.texture = null
	active_label.text = ""


func hide_all():
	active_actions.hide()


func set_active_object(object : IslandObject):
	_reset_active_elements()
	current_object = object
	active_label.text = object.object_name
	active_actions.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
