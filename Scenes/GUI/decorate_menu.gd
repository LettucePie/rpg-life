extends Control
class_name DecorateMenu

signal exit_decorate()

enum STATE {REST, EDIT, MOVE, PLACE}
var current_state : STATE = STATE.REST

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
#var latest_grid_button : GridButton = null

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
		var quantity : int = Persist.get_quantity_by_item_name_type(
			object.object_name,
			Persist.ItemEntry.ITEMTYPE.OBJECT
		)
		if quantity > 0:
			active_label.text += " | " + str(quantity)
		var extra_available : bool = quantity > 0
		_active_action_visibility([1, int(extra_available), 1])
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


## Freshly populates the Decoration Grid based on IslandObjects
## found within Persist. Avoid recalling after each inventory change.
func _populate_deco_grid():
	print("Populating DecoGrid")
	VPrint.vprint("Populating DecoGrid")
	
	if grid_buttons.size() > 0:
		for gb in grid_buttons:
			gb.queue_free()
	grid_buttons.clear()
	
	for item in Persist.inventory:
		if item.types.has(Persist.ItemEntry.ITEMTYPE.OBJECT):
			var io_data : IO_Data = null
			io_data = item.return_entry_of_type(Persist.ItemEntry.ITEMTYPE.OBJECT)
			if io_data != null:
				var new_grid_button : GridButton \
						= grid_button_scene.instantiate()
				new_grid_button.assign_island_object_data(io_data, item.quantity)
				new_grid_button.grid_button_pressed.connect(
						deco_button_pressed)
				new_grid_button.adoption(deco_storage_grid)
				grid_buttons.append(new_grid_button)
			else:
				## TODO fix this
				print("**ERROR** Failed to retrieve CompendiumEntry from \
Persist ItemEntry: ", item.item_name)
				VPrint.vprint("Failed to Catch IOC_entry for " + item.item_name)


func _update_deco_grid(deco_name : String, adjustment : int):
	print("Updating GridButton for: ", deco_name, " by: ", adjustment)
	var found : bool = false
	var remove : GridButton = null
	for button : GridButton in grid_buttons:
		if button.button_type == GridButton.BUTTON_TYPE.island_object \
		and button.data_ref[0].io_name == deco_name:
			found = true
			button.data_ref[1] += adjustment
			if button.data_ref[1] <= 0:
				remove = button
			else:
				button.update_button_text()
	if found == false:
		## Create new button in grid to be interacted with.
		## FIRST, validate with Persist.
		var io_data : IO_Data
		io_data = TheBox.request_io_data_by_name(deco_name)
		var quantity = Persist.get_quantity_by_item_name_type(
				deco_name, Persist.ItemEntry.ITEMTYPE.OBJECT)
		if quantity > 0 and io_data != null:
			var new_grid_button : GridButton = grid_button_scene.instantiate()
			new_grid_button.assign_island_object_data(io_data, quantity)
			new_grid_button.grid_button_pressed.connect(
					deco_button_pressed)
			new_grid_button.adoption(deco_storage_grid)
			grid_buttons.append(new_grid_button)
	if remove != null:
		grid_buttons.erase(remove)
		remove.queue_free()


func deco_button_pressed(grid_button : GridButton):
	print("Decorate Menu Received GridButton: ", grid_button)
	## Set target decoration into suspension, allowing it to be placed at
	## pointed position when player taps on their Island.
	## Then authenticate inventory.
	#latest_grid_button = grid_button
	if grid_button.button_type == grid_button.BUTTON_TYPE.island_object:
		if grid_button.data_ref[0] is IO_Data:
			place_in_suspension(grid_button.data_ref[0].io_scene.instantiate())
	spawn_tools.hide()


func place_in_suspension(island_object : IslandObject):
	print("Placing IslandObject: ", island_object.object_name, " into placement Suspension.")
	_reset_active_elements()
	suspended_island_object = island_object
	active_icon.texture.studio_capture_object(island_object)
	active_label.text = "Placing " + island_object.object_name
	#print(" Add Quantity to label")
	var new_quantity : int = Persist.get_quantity_by_item_name_type(
			suspended_island_object.object_name,
			Persist.ItemEntry.ITEMTYPE.OBJECT
	)
	active_label.text += " | " + str(new_quantity)
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


func suspension_status(tf : bool):
	if tf:
		print("DecoMenu call that suspended object has been placed.")
		_update_deco_grid(suspended_island_object.object_name, -1)
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
			place_in_suspension(suspended_island_object.duplicate())
		else:
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
	target_island.finish_manipulation()
	Persist.save_data()
	emit_signal("exit_decorate")
	## Save/update island data


func _active_buttons(id : int):
	if id == 0:
		print("Remove Active Decoration")
		if current_state == STATE.EDIT:
			if Persist.get_quantity_by_item_name_type(
					current_object.object_name, 
					Persist.ItemEntry.ITEMTYPE.OBJECT) > 0:
				## Persist has Inventory of item.
				Persist.update_quantity_by_item_name_type(
						current_object.object_name,
						Persist.ItemEntry.ITEMTYPE.OBJECT,
						1
				)
			else:
				## Persist does not have Inventory of item, add it.
				Persist.add_inventory_by_name_type(
						current_object.object_name,
						[Persist.ItemEntry.ITEMTYPE.OBJECT],
						1
				)
		_update_deco_grid(current_object.object_name, 1)
		target_island.remove_object(current_object)
		unset_active_object()
	elif id == 1:
		print("Duplicate Active Decoration")
		if current_state == STATE.EDIT and current_object != null:
			current_object.outline(false)
			var dupe : IslandObject = current_object.duplicate()
			unset_active_object()
			place_in_suspension(dupe)
			current_state = STATE.PLACE
	elif id == 2:
		print("Finish Manipulating Active Decoration")
		if current_state == STATE.EDIT:
			unset_active_object()
		elif current_state == STATE.PLACE:
			cancel_suspension()


func _on_spawn_button_pressed():
	if spawn_tools.visible:
		spawn_tools.hide()
	else:
		spawn_tools.show()
		edit_tools.hide()
		active_actions.hide()


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index <= 1 \
		and event.pressed \
		and (event.position.y / get_window().size.y) >= 0.8 \
		and current_state == STATE.EDIT:
			rotating = true
			print("Begin Rotating")
			##
			PlayerInput.movement_locked = true
	if rotating and event is InputEventMouseButton:
		if event.pressed == false:
			print("End Rotating")
			rotating = false
			##
			PlayerInput.movement_locked = false
	if rotating and event is InputEventMouseMotion:
		target_island.rotate_object(
				current_object, 
				(event.relative.x / PI) * PlayerInputManager.ROTATE_SPEED
		)
