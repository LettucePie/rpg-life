extends Control
class_name GalaxyMenu

@onready var inventory_sub : Control = $InventorySubMenu
@onready var connect_sub : Control = $ConnectSubMenu

var primary_menu_elements : Array = []
var auxillery_menus : Array = []

var menu_locked : bool = false
var current_submenu : int = -1


func _ready():
	_gather_menus()
	hide_all_submenus()
	hide_all_auxmenus()


func _gather_menus():
	primary_menu_elements.clear()
	auxillery_menus.clear()
	for child in get_children():
		if child.is_in_group("primary_menu"):
			primary_menu_elements.append(child)
		else:
			auxillery_menus.append(child)


func hide_all_primary():
	for control in primary_menu_elements:
		control.hide()


func hide_all_submenus():
	inventory_sub.hide()
	connect_sub.hide()
	print("Add more submenus as they are made")


func hide_all_auxmenus():
	for a_menu in auxillery_menus:
		a_menu.hide()


func bottom_row_button(id : int):
	if current_submenu != id:
		hide_all_submenus()
		current_submenu = id
		if id <= 0:
			print("Inventory Button")
			#hide_all_primary()
			inventory_sub.show()
		elif id == 1:
			print("Connect Button")
		elif id == 2:
			print("Battle Button")
	else:
		hide_all_submenus()
		current_submenu = -1
