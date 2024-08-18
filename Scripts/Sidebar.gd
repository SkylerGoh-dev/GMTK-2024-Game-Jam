class_name side_bar
extends PanelContainer

@onready var main_menu = $MarginContainer/Menu/InnerMenu
@onready var menu_parent = $MarginContainer/Menu/InnerMenu/VBoxContainer/VBoxContainer/MarginContainer
@onready var list_menu : GridContainer = $MarginContainer/Menu/InnerMenu/VBoxContainer2/VBoxContainer/MarginContainer/listMenu
@onready var week: Label = $MarginContainer/Menu/InnerMenu/VBoxContainer2/Week
@onready var explanation: Label = $MarginContainer/Menu/InnerMenu/VBoxContainer2/VBoxContainer/Explanation
@onready var inner_menu: Panel = $MarginContainer/Menu/InnerMenu

@onready var arrow_up = $MarginContainer/Menu/Tab/PullDownTab/ArrowUp
@onready var arrow_down= $MarginContainer/Menu/Tab/PullDownTab/ArrowDown

const ITEM = preload("res://Scenes/shopping list UI/item.tscn")
var total_items: int = 0
var item_list: Dictionary = {}

func _ready():
	main_menu.visible = false
	list_menu.visible = false
	arrow_up.visible = false
	arrow_down.visible = true
	Gameplay_Manager.shopping_list = self
	explanation.text = Gameplay_Manager.get_shopping_list_dialog()

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

func set_explanation(dialog: String):
	explanation.text = dialog

func add_ui_item(item: String, amount: int):
	total_items+= 1
	var instance : Item = ITEM.instantiate()
	list_menu.add_child(instance)
	instance.label.text = "0/" + str(amount) + " " + item 
	item_list[item] = instance
	resize_menu()

func update_ui_item(item: String, amount: int):
	var item_node : Item = item_list[item]
	item_node.label.text = str(amount) + item_node.label.text.substr(1)

func cross_ui_item(item: String):
	var item_node : Item = item_list[item]
	item_node.h_separator.show()

func resize_menu():
	if explanation.size.y > 150:
		if total_items >= 2 and total_items < 6:
			inner_menu.custom_minimum_size = Vector2i(0,400)
		elif total_items >= 6:
			inner_menu.custom_minimum_size = Vector2i(0,500)
	elif explanation.size.y > 70:
		if total_items >= 6:
			inner_menu.custom_minimum_size = Vector2i(0,400)
	else:
		inner_menu.custom_minimum_size = Vector2i(0,300)
	print(inner_menu.custom_minimum_size)

func clear_list():
	total_items = 0
	for child in list_menu.get_children():
		child.queue_free()
