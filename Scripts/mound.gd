extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var mound_collision = $MoundCollision
@onready var interaction_area = $Interaction_Area
@onready var hole_collision = $HoleCollision
@onready var animation = $AnimationPlayer
@export var canvas_layer : CanvasLayer

var shovel_game = null
var has_shovel = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gameplay_Manager._register_item(Resource_Name.type["MANURE"], 4)
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.frame = 0
	hole_collision.disabled = true

func _on_interact():
	if has_shovel:
		canvas_layer.hide_ui()
		if not shovel_game:
			shovel_game = preload("res://Scenes/shovel_game.tscn").instantiate()
			shovel_game.position = Vector2(640, 360)
			canvas_layer.call_deferred("add_child", shovel_game)
		else:
			SoundManager.play_sound(self, "02-ButtonHover")
			shovel_game.visible = true
			
	else:
		animation.play("emit_text")
		SoundManager.play_sound(self, "24-Cant_Dig_Dirt")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shovel_game:
		if shovel_game.done_diggin:
			sprite.frame = 1
			mound_collision.disabled = true
			hole_collision.disabled = false


func _on_interactable_item_shovel() -> void:
	has_shovel = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	print('exited')
	if shovel_game and body.name == 'Player':
		shovel_game.visible = false
		canvas_layer.show_ui()
		if not shovel_game.animation.current_animation == "reveal":
			shovel_game.animation.stop()
			shovel_game.reset_game()
