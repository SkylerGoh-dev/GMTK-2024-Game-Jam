extends CharacterBody2D
class_name napkin_box

const MAX_NAPKINS = 5

var direction = Vector2.ZERO
@export var clickable = false
@export var game_field: NodePath

var napkins = []
static var isInside = false

@onready var napkin_spawner = $NapkinSpawner
@onready var napkin_box_area = $Area2D
@onready var collision_shape = $CollisionShape2D  # Reference to the CollisionShape2D

func _ready():
	$Timer.start()

func _physics_process(delta: float) -> void:
	var curr_mouse_pos = get_global_mouse_position()

func spawn_napkin() -> Node2D:
	if napkins.size() >= MAX_NAPKINS:
		var oldest_napkin = napkins.pop_front()
		if is_instance_valid(oldest_napkin):
			oldest_napkin.queue_free()

	var napkin = preload("res://Scenes/napkin.tscn").instantiate()
	napkin.scale = Vector2(1, 1)
	napkin.global_position = napkin_box_area.global_position
	get_parent().call_deferred("add_child", napkin)
	napkins.append(napkin)

	var direction = Vector2(randf_range(-1, 1), -1).normalized()
	var speed = randf_range(100, 150)
	napkin.velocity = direction * speed

	return napkin

func _on_timer_timeout() -> void:
	spawn_napkin()
	#Sound:: Napkin Shoot
	$Timer.start()
	
func _on_area_2d_mouse_entered() -> void:
	isInside = true


func _on_area_2d_mouse_exited() -> void:
	isInside = false
