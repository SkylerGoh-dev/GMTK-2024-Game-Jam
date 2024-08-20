extends CharacterBody2D

var bullet = preload("res://Scenes/bullet.tscn")
var fire_rate = 0.4
var gun_cooldown = 0
@onready var sprite: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	print(get_global_mouse_position())
	var player = get_parent()
	if (get_global_mouse_position().x < player.position.x):
		sprite.flip_v = true
		sprite.global_position = player.position - Vector2(8, 0)
		print("2")
	else:
		print("1")
		sprite.flip_v = false
		sprite.global_position = player.position + Vector2(8, 0)
	
	gun_cooldown += delta
	if Input.is_action_pressed("press") and gun_cooldown >= fire_rate:
		fire_gun()
		gun_cooldown = 0

func fire_gun():
	var new_bullet = bullet.instantiate()
	new_bullet.rotation = global_rotation + 1.55
	new_bullet.global_position = global_position
	new_bullet.visible = true;
	get_tree().root.add_child(new_bullet)

#https://forum.godotengine.org/t/godot-4-top-down-shooter/490/2
