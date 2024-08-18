extends Node2D

@onready var interaction_area: Interaction_Area = $Interaction_Area
var panel_open : bool = false
var chicken_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	chicken_game = preload("res://Scenes/chicken_game.tscn").instantiate()
	get_tree().root.call_deferred("add_child", chicken_game)
	panel_open = true
