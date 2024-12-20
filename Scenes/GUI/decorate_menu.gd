extends Control
class_name DecorateMenu

signal exit_decorate()

enum STATE {REST, EDIT, MOVE, PLACE}
var current_state : STATE = STATE.REST

## Constants
const ROTATE_SPEED : float = 0.045

## Active Elements
var target_island : Island
var current_object : IslandObject
var suspended_island_object : IslandObject = null
@onready var active_actions : Control = $ActiveHUD
@onready var active_icon : TextureRect = $ActiveHUD/ActiveVbox/ActiveIcon
@onready var active_label : Label = $ActiveHUD/ActiveVbox/ActiveLabel
var grid_buttons : Array = []
@onready var deco_storage_grid : GridContainer = \
$Spawn_Toolset/Panel/List/GridPanel/GridScroll/GridContainer
var latest_grid_button : GridButton = null

## Static Elements
@onready var back_button : BaseButton = $Upper_Left_Action/BackButton
@onready var spawn_button : BaseButton = $Upper_Right_Action/SpawnButton
@onready var edit_tools : Control = $Edit_Toolset
@onready var spawn_tools : Control = $Spawn_Toolset
var grid_button_scene : PackedScene = preload("res://Scenes/GUI/grid_button.tscn")
@onready var active_action_buttons : Array = [
	$ActiveHUD/ActiveVbox/ActiveActions/RemoveActive,
	$ActiveHUD/ActiveVbox/ActiveActions/DuplicateActive,
	$ActiveHUD/ActiveVbox/ActiveActions/DoneActive
]

## Tool States
var rotating : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	clean()


func prepare_deco_menu():
	clean()
	_populate_deco_grid()
	self.show()


func clean():
	current_object = null
	suspended_island_object = null
	_reset_active_elements()
	hide_all()
	current_state = STATE.REST


func _reset_active_elements():
	active_icon.texture.clear_object()
	active_label.text = ""


func hide_all():
	active_actions.hide()
	back_button.show()
	spawn_button.show()
	edit_tools.hide()
	spawn_tools.hide()


func set_active_object(object : IslandObject) -> bool:
	if current_state != STATE.REST:
		return false
	else:
		_reset_active_elements()
		current_object = object
		current_object.outline(true)
		active_icon.texture.studio_capture_object(object)
		active_label.text = object.object_name
		_active_action_visibility([1, 1, 1])
		active_actions.show()
		back_button.hide()
		spawn_button.hide()
		edit_tools.show()
		##
		PlayerInput.movement_locked = false
		current_state = STATE.EDIT
		return true


func quickset_active_object(object : IslandObject):
	unset_active_object()
	set_active_object(object)


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
	current_state = STATE.REST


func _active_action_visibility(bools : PackedByteArray):
	if bools.size() == active_action_buttons.size():
		for i in bools.size():
			active_action_buttons[i].visible = bools[i]


func _populate_deco_grid():
	print("Populating DecoGrid")
	
	if grid_buttons.size() > 0:
		for gb in grid_buttons:
			gb.queue_free()
	grid_buttons.clear()
	
	for item in Persist.inventory:
		if item.types.has(Persist.ItemEntry.ITEMTYPE.OBJECT):
			var entry : IslandObjectCompendium.CompendiumEntry = null
			entry = item.return_entry_of_type(Persist.ItemEntry.ITEMTYPE.OBJECT)
			if entry != null:
				var new_grid_button : GridButton \
						= grid_button_scene.instantiate()
				new_grid_button.assign_island_object_entry(entry, item.quantity)
				new_grid_button.grid_button_pressed.connect(
						deco_button_pressed)
				new_grid_button.adoption(deco_storage_grid)
				grid_buttons.append(new_grid_button)
			else:
				print("**ERROR** Failed to retrieve CompendiumEntry from \
					Persist ItemEntry: ", item.item_name)


func deco_button_pressed(grid_button : GridButton):
	print("Decorate Menu Received GridButton: ", grid_button)
	## Set target decoration into suspension, allowing it to be placed at
	## pointed position when player taps on their Island.
	## Then authenticate inventory.
	latest_grid_button = grid_button
	if grid_button.button_type == grid_button.BUTTON_TYPE.island_object:
		place_in_suspension(IslandObjectCompendium.request_io_scene_by_entry(
				grid_button.data_ref[0]).instantiate())
	spawn_tools.hide()


func place_in_suspension(island_object : IslandObject) -> bool:
	if current_state != STATE.REST:
		return false
	else:
		print("Placing IslandObject: ", island_object.object_name, " into placement Suspension.")
		_reset_active_elements()
		suspended_island_object = island_object
		active_icon.texture.studio_capture_object(island_object)
		active_label.text = "Placing " + island_object.object_name
		print(" Add Quantity to label")
		active_actions.show()
		_active_action_visibility([0, 0, 1])
		back_button.hide()
		spawn_button.hide()
		edit_tools.hide()
		current_state = STATE.PLACE
		target_island.setup_suspended_island_object(
			suspended_island_object, self.suspension_status
		)
		##
		PlayerInput.movement_locked = false
		return true


func suspension_status(tf : bool):
	if tf:
		print("DecoMenu call that suspended object has been placed.")
		Persist.update_quantity_by_item_name_type(
			suspended_island_object.object_name,
			Persist.ItemEntry.ITEMTYPE.OBJECT,
			-1
		)
		var new_quantity : int = Persist.get_quantity_by_item_name_type(
			suspended_island_object.object_name,
			Persist.ItemEntry.ITEMTYPE.OBJECT
		)
		if new_quantity > 0:
			latest_grid_button.assign_island_object_entry(
				latest_grid_button.data_ref[0],
				new_quantity
			)
		else:
			grid_buttons.erase(latest_grid_button)
			latest_grid_button.queue_free()
		cancel_suspension()
		
	else:
		print("DecoMenu call that suspended object has Not been placed.")
		cancel_suspension()


func cancel_suspension():
	print("unsuspend object i guess")
	suspended_island_object = null
	current_state = STATE.REST
	target_island.cancel_suspended_island_object()
	_reset_active_elements()
	#hide_all()
	spawn_tools.show()
	edit_tools.hide()
	active_actions.hide()
	spawn_button.show()
	back_button.show()


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
		if current_state == STATE.EDIT:
			unset_active_object()
		elif current_state == STATE.PLACE:
			cancel_suspension()


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
		edit_tools.hide()
		active_actions.hide()


func _input(event):
	if rotating and event is InputEventMouseButton:
		if event.pressed == false:
			print("End Rotating")
			rotating = false
			##
			PlayerInput.movement_locked = false
	if rotating and event is InputEventMouseMotion:
		current_object.rotate_y((event.relative.x / PI) * ROTATE_SPEED)

