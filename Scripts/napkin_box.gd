extends CharacterBody2D

const MAX_NAPKINS = 5

var direction = Vector2.ZERO
@export var clickable = false
@export var game_field: NodePath

var napkin_spawned = false
var inside_Napkin_Box = false
var dragging_napkin = null
var napkins = []

@onready var napkin_spawner = $NapkinSpawner
@onready var napkin_box_area = $Area2D

func _ready():
	pass

func _physics_process(delta: float) -> void:
	var curr_mouse_pos = get_global_mouse_position()

	# Start dragging
	if Input.is_action_just_pressed("press") and inside_Napkin_Box:
		dragging_napkin = spawn_napkin()
		napkin_spawned = true

	# Drag napkin
	if dragging_napkin:
		dragging_napkin.global_position = curr_mouse_pos
		if Input.is_action_just_released("press"):
			dragging_napkin = null
			napkin_spawned = false

func spawn_napkin() -> Node2D:
	if napkins.size() >= MAX_NAPKINS:
		var oldest_napkin = napkins.pop_front()
		if oldest_napkin and not null:
			oldest_napkin.queue_free()

	var napkin = preload("res://Scenes/napkin.tscn").instantiate()
	napkin.scale = Vector2(0.7, 0.7)
	napkin.global_position = get_global_mouse_position()
	get_parent().call_deferred("add_child", napkin)
	napkins.append(napkin)
	return napkin

func _on_area_2d_mouse_entered() -> void:
	inside_Napkin_Box = true
	if not dragging_napkin:
		scale = Vector2(1.2, 1.2)
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited() -> void:
	inside_Napkin_Box = false
	scale = Vector2(1, 1)
	if not dragging_napkin:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
