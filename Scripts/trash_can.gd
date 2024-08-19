extends CharacterBody2D

const MAX_TRASH_BAGS = 5

var direction = Vector2.ZERO
@export var clickable = false
@export var game_field: NodePath

var trash_bag_spawned = false
var inside_trash_bag_Box = false
var dragging_trash_bag = null
var bags = []

@onready var trash_bag_spawner = $trash_bag_Spawner
@onready var napkin_box_area = $Area2D

func _ready():
	pass

func _physics_process(delta: float) -> void:
	var curr_mouse_pos = get_global_mouse_position()

	# Start dragging
	if Input.is_action_just_pressed("press") and inside_trash_bag_Box:
		dragging_trash_bag = spawn_napkin()
		trash_bag_spawned = true

	# Drag napkin
	if dragging_trash_bag:
		dragging_trash_bag.global_position = curr_mouse_pos
		if Input.is_action_just_released("press"):
			dragging_trash_bag = null
			trash_bag_spawned = false

func spawn_napkin() -> Node2D:
	if bags.size() >= MAX_TRASH_BAGS:
		var oldest_bag = bags.pop_front()
		if is_instance_valid(oldest_bag):
			oldest_bag.queue_free()

	var trash_bag = preload("res://Scenes/trash_bag.tscn").instantiate()
	trash_bag.scale = Vector2(2.3, 2.3)
	trash_bag.global_position = get_global_mouse_position()
	get_parent().call_deferred("add_child", trash_bag)
	bags.append(trash_bag)
	return trash_bag

func _on_area_2d_mouse_entered() -> void:
	inside_trash_bag_Box = true
	if not dragging_trash_bag:
		scale = Vector2(3.3, 3.3)
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited() -> void:
	inside_trash_bag_Box = false
	scale = Vector2(3, 3)
	if not dragging_trash_bag:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
