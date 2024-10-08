extends Node

var pause_menu

# Gameplay Flags
@export var current_week: int = 0
var scene_items: Dictionary = {}
var completed_items: Dictionary = {}
var scene_changing: bool = false
var max_weeks: int = 10
var inventoryResource: InventoryResource 
var inventory_open : bool = false
var talked_to_clerk: bool = false
var hovered_items: Array = []
var win_game: bool = false

#reference
var npc_clerk : clerk = null
var shopping_list: side_bar = null
# Scene Transition dialog
var transition_dialog : Array = [
	"Grandma made lasagna for dinner. It was super delicious!", 
	"This week’s list was a bit long but it was fun making a fruit cake with Grandma!",
	"That toaster was hard to bring back. It seemed Grandma needed the rope for something 
	important in the basement. When she got back, she brought ice cream!",
	"That picnic with grandma was a blast! But, I wonder where those oleanders I got Grandma went. 
	We drank delicious green tea instead.",
	"I cleaned the entire kitchen! Grandma was so proud when she finished cleaning the the basement.",
	"Hmm… dinner with Grandma was nice as usual, but the beef tasted a little funny this time.",	
	"I tripped on a dirt pile in the backyard. Grandma looked really worried, but I’ll show her how healthy I still am!",
	"I was sad we were moving, but the road trip was Grandma was fun!",
	"Grandma had a scary look on her face. I ran to the store as fast as possible.",
	"Grandma tried to kill me. I..I had no choice ",
]
# Shopping List explanation
var grandma_dialog = [
	"Grandma ran out of Cheese. Can you please pick some up?",
	"Grandma misplaced her kitchen knife. Please get me one from the store along with some fruits.",
	"Oh no sweetie! The toaster fell into the bath. Could you be a dear and buy me a new one? 
	And get me some spare rope for outside while you’re there!",
	"Let’s go on a picnic today! Grab those pretty Oleanders, eggs, and your favorite food to eat.",
	"Grandma needs to restock on new cleaning supplies. She had some troublesome stains to take care of.",
	"Grab all the meat you can get from the store <3",
	"Grandma is thinking of improving the garden. Can you grab some extra tools? Especially, one that can dig",
	"Grab everything we are moving",
	"Grandma made a mistake",
	"You know too much"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var current_scene_name :String = get_tree().current_scene.name
	var current_scene_num : int = int(current_scene_name.substr(current_scene_name.length()-1))
	if current_scene_num <= max_weeks and current_scene_num != current_week:
		print("changed current week to scene week to", current_scene_num)
		current_week = current_scene_num

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc") and get_tree().root.get_node_or_null("Pause_Menu") == null:
		if inventory_open:
			inventory_open = false
		else:
			if current_week != 0:
				create_pause()
				print('esc clicked pause')
		
	elif Input.is_action_just_pressed("esc") and get_tree().root.get_node_or_null("Pause_Menu") != null:
		print('esc clicked resume')
		create_resume()

func create_pause():
	pause_menu = preload("res://Scenes/pause_menu.tscn").instantiate()
	pause_menu.name = "Pause_Menu"
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
	
func update_item_completion(item: String, amount: int):
	var lower_item = item.to_lower()
	if lower_item not in scene_items.keys():
		return
	shopping_list.update_ui_item(lower_item,amount)
	if scene_items[lower_item] == amount:
		completed_items[lower_item] = true	
		shopping_list.cross_ui_item(lower_item)
	if are_items_collected() and npc_clerk:
		npc_clerk.show_indicator()

func are_items_collected():
	if current_week == max_weeks:
		return win_game
	for item in completed_items.values():
		if not item:
			return false
	return true

func end_week():
	if are_items_collected() and talked_to_clerk:
		if current_week <= max_weeks:
			current_week+= 1
		clear_needed_items()
		go_to_scene_transition()

func clear_needed_items() ->void:
	talked_to_clerk = false
	inventoryResource.clearAll()
	scene_items.clear()
	completed_items.clear()
	shopping_list.clear_list()

func next_level_path() -> String:
	#scene_changing = false
	print("currentweek: ", current_week)
	if current_week > max_weeks:
		current_week = 0
		return "res://Scenes/levels/beginning_scene.tscn"
	return "res://Scenes/levels/main" + str(current_week) + ".tscn"
	#return "res://Scenes/levels/main.tscn"

func go_to_scene_transition():
	get_tree().change_scene_to_file("res://Scenes/scene_transition.tscn")

func get_transition_dialog() -> String:
	if current_week-2 < transition_dialog.size():
		return transition_dialog[current_week-2]
	return transition_dialog[current_week-1]

func get_shopping_list_dialog() -> String:
	if current_week-1 < grandma_dialog.size():
		return grandma_dialog[current_week-1]
	return ""
func get_current_week() -> int:
	return current_week
		
func item_finished(item: String) -> bool:
	if item in completed_items.keys():
		return completed_items[item]
	return false

func set_clerk_flag():
	talked_to_clerk = true

func add_hovered(object: CharacterBody2D):
	hovered_items.push_front(object)
	if hovered_items.size() > 1:
		hovered_items.pop_back()
