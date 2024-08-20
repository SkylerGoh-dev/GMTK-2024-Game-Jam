extends Control

@onready var walls = $StaticBody2D/CollisionPolygon2D
@onready var chickens = $Chickens

@export var speeder : int = 200
@export var eggs_needed : int = 2
@export var will_rest : bool = true

signal chicken_game_closed

func _ready():
	set_deferred("visible", false)
	walls.set_deferred("disabled", true)
	Gameplay_Manager._register_item(13,eggs_needed)
	for chicken in chickens.get_children():
		chicken.speed = speeder
		chicken.will_rest = will_rest
		chicken.origin = chickens.position

func _on_button_pressed() -> void:
	visible = false
	chicken_game_closed.emit()
	walls.set_deferred("disabled", true)

func _on_button_mouse_entered() -> void:
	$Button.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)

func _on_button_mouse_exited() -> void:
	$Button.set_default_cursor_shape(Control.CURSOR_ARROW)
