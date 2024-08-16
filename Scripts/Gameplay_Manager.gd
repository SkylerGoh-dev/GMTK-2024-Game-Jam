extends Node

var pause_menu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu = preload("res://Scenes/pause_menu.tscn").instantiate()
	get_tree().get_root().get_node("Main").add_child(pause_menu)
	print(pause_menu)
