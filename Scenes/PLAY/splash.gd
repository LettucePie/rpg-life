extends Control
## Loads up the Asset Compendiums in staggered order

@export var galaxy_play : PackedScene

enum LOADSTATE {FROZEN, STARTED, DONE}
var io_state : LOADSTATE = LOADSTATE.FROZEN
var mat_state : LOADSTATE = LOADSTATE.FROZEN
var equip_state : LOADSTATE = LOADSTATE.FROZEN
var player_state : LOADSTATE = LOADSTATE.FROZEN

var target : int = -1

@onready var progress_label : Label = $Control/VBoxContainer/Progress

func _ready():
	target = -1
	_load_step()


func _load_step():
	if target < 0 and io_state == LOADSTATE.FROZEN:
		target = 0
		IslandObjectCompendium.io_catalogued.connect(_asset_checked_in)
		io_state = LOADSTATE.STARTED
		progress_label.text = "Loading IO..."
		IslandObjectCompendium.rebuild_compendium_from_data()
	if target == 0 and player_state == LOADSTATE.FROZEN:
		target = 3
		Persist.finished_loading.connect(_asset_checked_in)
		player_state = LOADSTATE.STARTED
		progress_label.text += "\nLoading PlayerData..."
		Persist.load_data()
	if target == 3 \
	and io_state == LOADSTATE.DONE \
	and player_state == LOADSTATE.DONE:
		print("ME")
		target = 99
		_setup_galaxy_play()


func _asset_checked_in():
	print("Asset Checked in at target: ", target)
	if target == 0 and io_state == LOADSTATE.STARTED:
		print("Island Object Compendium finished loading.")
		progress_label.text += "\nIO Loaded!"
		io_state = LOADSTATE.DONE
	if target == 3 and player_state == LOADSTATE.STARTED:
		print("Player Data finished loading.")
		progress_label.text += "\nPlayerData Loaded!"
		player_state = LOADSTATE.DONE
	
	_load_step()


func _setup_galaxy_play():
	print("Setting up Galaxy")
	var galaxy = galaxy_play.instantiate()
	get_window().add_child.call_deferred(galaxy)
	galaxy.call_deferred("initialize")
	self.queue_free()
