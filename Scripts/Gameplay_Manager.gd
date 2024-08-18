extends Node

var pause_menu

# Gameplay Flags
@export var current_week: int = 1
var scene_items: Dictionary = {}
var completed_items: Dictionary = {}
var scene_changing: bool = false
var max_weeks: int = 2
var inventoryResource: InventoryResource 

#reference
var npc_clerk : clerk = null
var shopping_list: side_bar = null
# Scene Transition dialog
var transition_dialog = [
	"Grandma Seems off"
]
# Shopping List explanation
var grandma_dialog = [
	"Grandma ran out of Cheese. Can you please pick some up?",
	"I’ve lost my butter knife, and really want to butter up my bread. Could you buy me one from the store?",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta) -> void:
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		create_pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		create_resume()

func create_pause():
	pause_menu = preload("res://Scenes/pause_menu.tscn").instantiate()
	get_tree().get_root().add_child(pause_menu)
	pause_menu.show()
	get_tree().paused = true

func create_resume():
	pause_menu.resume()
	
## depots will register their items for the week to gameplay manager 
## this will happen when _ready func for depots is called 
## Should not be called after ready func 
func _register_item(item: Resource_Name.type, amount: int):
	var resource_name : String = Resource_Name.type.keys()[item].to_lower()
	if resource_name not in scene_items.keys():
		scene_items[resource_name] = amount
		completed_items[resource_name] = false
		shopping_list.add_ui_item(resource_name,amount)
	print(scene_items)
	print(completed_items)
	
func update_item_completion(item: String, amount: int):
	print("trying to update", item, "with amount: ", amount)
	var lower_item = item.to_lower()
	if lower_item not in scene_items.keys():
		return
	shopping_list.update_ui_item(lower_item,amount)
	if scene_items[lower_item] == amount:
		completed_items[lower_item] = true	
		shopping_list.cross_ui_item(lower_item)
	if are_items_colected() and npc_clerk:
		npc_clerk.show_indicator()

func are_items_colected():
	for item in completed_items.values():
		if not item:
			return false
	return true

func end_week():
	if are_items_colected():
		if current_week+1 <= max_weeks:
			current_week+= 1
		clear_needed_items()
		go_to_scene_transition()

func clear_needed_items() ->void:
	inventoryResource.clearAll()
	scene_items.clear()
	completed_items.clear()
	shopping_list.clear_list()

func next_level_path() -> String:
	#scene_changing = false
	return "res://Scenes/levels/main" + str(current_week) + ".tscn"
	#return "res://Scenes/levels/main.tscn"

func go_to_scene_transition():
	get_tree().change_scene_to_file("res://Scenes/scene_transition.tscn")

func get_transition_dialog() -> String:
	if current_week-2 < transition_dialog.size():
		return transition_dialog[current_week-2]
	return ""

func get_shopping_list_dialog() -> String:
	if current_week-1 < grandma_dialog.size():
		return grandma_dialog[current_week-1]
	return ""
		
func item_finished(item: String) -> bool:
	if item in completed_items.keys():
		return completed_items[item]
	return false
