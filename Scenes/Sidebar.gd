extends PanelContainer

@onready var main_menu = $MarginContainer/Menu/InnerMenu
@onready var menu_parent = $MarginContainer/Menu/InnerMenu/VBoxContainer/VBoxContainer/MarginContainer
@onready var list_menu = $MarginContainer/Menu/InnerMenu/VBoxContainer2/VBoxContainer/MarginContainer/listMenu

@onready var arrow_up = $MarginContainer/Menu/Tab/PullDownTab/ArrowUp
@onready var arrow_down= $MarginContainer/Menu/Tab/PullDownTab/ArrowDown

func _ready():
	main_menu.visible = false
	
	list_menu.visible = false
	arrow_up.visible = false
	arrow_down.visible = true

func _set_menu(menu):
	var wasClosed = menu.visible == false
	main_menu.visible = wasClosed
	menu.visible = wasClosed
	
	if wasClosed:
		arrow_up.visible = true
		arrow_down.visible = false
		#Closed
	else:
		arrow_down.visible = true
		arrow_up.visible = false
		#Open


func _on_open_list_menu_pressed():
	_set_menu(list_menu)
