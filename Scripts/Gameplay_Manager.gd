extends Node

var pause_menu

# Gameplay Flags
@export var current_week: int = 1
var scene_items: Dictionary = {}
var completed_items: Dictionary = {}

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
	scene_items[Resource_Name.type.keys()[item].to_lower()] = amount
	completed_items[Resource_Name.type.keys()[item].to_lower()] = false
	print(scene_items)
	print(completed_items)
	
func update_item_completion(item: String, amount: int):
	if scene_items[item.to_lower()] == amount:
		completed_items[item.to_lower()] = true	
	print(completed_items)
	print(are_items_colected())

func are_items_colected():
	for item in completed_items.values():
		if not item:
			return false
	return true

func clear_needed_items() ->void:
	scene_items.clear()
	completed_items.clear()
