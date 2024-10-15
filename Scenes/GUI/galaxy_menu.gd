extends Control
class_name GalaxyMenu
## Governs the Primary and Secondary (Sub) menus.
## Visibility State Machine

enum MENU_STATES {
	FREE,
	SUBMENU,
	DECORATE
}

var state : MENU_STATES = MENU_STATES.FREE

## Submenu Stuff
@onready var submenu_root : Control = $SubMenus
@onready var inventory_sub : Control = $SubMenus/InventorySubMenu
@onready var connect_sub : Control = $SubMenus/ConnectSubMenu

## Auxillery Menu Stuff
@onready var decoration_menu : DecorateMenu = $DecorateMenu

var primary_menu_elements : Array = []
var auxillery_menus : Array = []

var menu_locked : bool = false
var current_submenu : int = -1


func _ready():
	_gather_menus()
	hide_all_submenus(true)
	hide_all_auxmenus()


func _gather_menus():
	primary_menu_elements.clear()
	auxillery_menus.clear()
	for child in get_children():
		if child.is_in_group("primary_menu"):
			primary_menu_elements.append(child)
		else:
			auxillery_menus.append(child)


func set_menu_state(new_state : MENU_STATES):
	state = new_state


func hide_all_primary():
	for control in primary_menu_elements:
		control.hide()


func hide_all_submenus(thorough : bool):
	if thorough:
		for child in submenu_root.get_children():
			child.hide()
	submenu_root.hide()


func hide_all_auxmenus():
	for a_menu in auxillery_menus:
		a_menu.hide()


func bottom_row_button(id : int):
	print("Bottom Row Button: ", id)
	if current_submenu != id:
		hide_all_submenus(true)
		submenu_root.show()
		current_submenu = id
		set_menu_state(MENU_STATES.SUBMENU)
		if id <= 0:
			print("Inventory Button")
			#hide_all_primary()
			inventory_sub.show()
		elif id == 1:
			print("Connect Button")
		elif id == 2:
			print("Battle Button")
	else:
		hide_all_submenus(true)
		current_submenu = -1
		set_menu_state(MENU_STATES.FREE)


func inventory_sub_button(id : int):
	if id <= 0:
		print("Show Stock")
	elif id == 1:
		print("Show Crafting")
	elif id == 2:
		print("Show Decoration Menu")
		hide_all_submenus(false)
		hide_all_primary()
		decoration_menu.show()
		set_menu_state(MENU_STATES.DECORATE)
