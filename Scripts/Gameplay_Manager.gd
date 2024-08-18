extends Node

var pause_menu
var panel_open: bool = false
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
