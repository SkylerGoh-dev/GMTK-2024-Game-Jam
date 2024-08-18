extends CharacterBody2D

const SPEED = 200
const DRAG_SPEED = 20

var direction = Vector2.ZERO
var hotspot = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var draggable = false
@export var clickable = false
@export var roam_dist = 64

var previous_mouse_position : Vector2
@export var shake_threshold : float = 40.0
var shake_detected : bool = false
var direction_changes : int = 0
var max_direction_changes : int = 20

@onready var sprite = $AnimatedSprite2D
@onready var rest_timer = $Rest
@onready var walk_timer = $Walk
@onready var egg_spawner = $EggSpawner
@onready var animation = $AnimationPlayer

#@export var roam_dist = 8

func _ready():
	pass

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if draggable:
		var curr_mouse_pos = get_global_mouse_position()
		var movement = curr_mouse_pos - previous_mouse_position
		
		if Input.is_action_just_pressed("press"):
			direction = curr_mouse_pos - global_position
			Interaction_Manager.is_dragging = true
		if Input.is_action_pressed("press"):
			direction = curr_mouse_pos - global_position
			velocity = direction * DRAG_SPEED
			sprite.play("angry")
			
		if Input.is_action_just_released("press"):
			Interaction_Manager.is_dragging = false
			unhand_me()
		
		if movement.length() > shake_threshold:
			var angle = movement.angle()
			var previous_movement = previous_mouse_position - get_global_mouse_position()
			
			if direction_changes == 0 or sign(angle) != sign(previous_movement.angle()):
				direction_changes += 1
				
				if direction_changes > max_direction_changes and not animation.is_playing() and Input.is_action_pressed("press"):
					animation.play("fade_out")
			
			if direction_changes == max_direction_changes:
				print("shook")
				spawn_egg()
	
	else:
		direction = position.direction_to(hotspot)
		if direction and abs(position - hotspot) > Vector2(2, 2):
			sprite.play("walk")
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			sprite.play("idle")
	
	move_and_slide()

func get_new_pos():
	var neg_x = -roam_dist - position.x
	var pos_x = roam_dist - position.x
	var neg_y = -roam_dist - position.y
	var pos_y = roam_dist - position.y
	hotspot.x = rng.randf_range(neg_x, pos_x) + position.x
	hotspot.y = rng.randf_range(neg_y, pos_y) + position.y

func roam():
	rest_timer.stop()
	get_new_pos()
	walk_timer.start(rng.randf_range(1.0,3.0))

func rest():
	walk_timer.stop()
	hotspot = position
	direction = Vector2.ZERO
	rest_timer.start(rng.randf_range(1.0,3.0))

func unhand_me():
	if not Interaction_Manager.is_dragging:
		draggable = false
		scale = Vector2(1,1)
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func spawn_egg():
	var egg = preload("res://Scenes/egg.tscn").instantiate()
	egg.scale = Vector2(0.7,0.7)
	egg.position = position + egg_spawner.position
	egg.velocity = velocity / 7.5
	get_parent().call_deferred("add_child", egg)

func _on_rest_timeout() -> void:
	roam()

func _on_walk_timeout() -> void:
	rest()

func _on_area_2d_mouse_entered() -> void:
	if not Interaction_Manager.is_dragging and clickable:
		draggable = true
		scale = Vector2(1.2, 1.2)
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		previous_mouse_position = get_global_mouse_position()

func _on_area_2d_mouse_exited() -> void:
	unhand_me()
