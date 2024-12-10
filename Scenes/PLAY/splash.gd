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


func _asset_checked_in():
	if target == 0 and io_state == LOADSTATE.STARTED:
		print("Island Object Compendium finished loading.")
		progress_label.text += "\nIO Loaded!"
	
	_load_step()
