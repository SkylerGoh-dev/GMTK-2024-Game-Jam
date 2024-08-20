extends Node2D

@onready var interaction_area: Interaction_Area = $Interaction_Area
@onready var chickens = $Chickens
var panel_open : bool = false
@onready var item_indicator: AnimatedSprite2D = $Item_Indicator

@export var chicken_game : Control 

signal chicken_game_opened


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	for chicken in chickens.get_children():
		chicken.origin = chickens.position
		print(chicken.position, chickens.position)
	item_indicator.play("default")

func _on_interact():
	chicken_game.set_deferred("visible", true)
	chicken_game.walls.set_deferred("disabled", false)
	panel_open = true
	item_indicator.hide()
	chicken_game_opened.emit()
