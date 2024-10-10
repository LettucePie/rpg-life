extends IslandObject
class_name Station

enum StationType {
	House,
	Farm,
	Mine
}

@export var station_type : StationType

func _ready():
	initialize()
	if !is_in_group("Station"):
		add_to_group("Station")
