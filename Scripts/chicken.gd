extends CharacterBody2D

const DRAG_SPEED = 20

var will_rest = true
@export var speed = 200
var direction = Vector2.ZERO
var hotspot = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var draggable = false
var laid_egg = false
@export var clickable = false
@export var roam_dist = Vector2(48,48)
var origin = Vector2.ZERO

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

func _ready():
	pass

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Gameplay_Manager.hovered_items.has(self) and not draggable:
		register_clickable()
		if not previous_mouse_position:
			previous_mouse_position = get_global_mouse_position()
	elif not Gameplay_Manager.hovered_items.has(self) and draggable:
		unhand_me()
	
	if draggable:
		var curr_mouse_pos = get_global_mouse_position()
		var movement = curr_mouse_pos - previous_mouse_position
		
		if Input.is_action_just_pressed("press"):
			direction = curr_mouse_pos - global_position
			Interaction_Manager.is_dragging = true
			SoundManager.play_sound(self, "16-Chicken_PickUp")
		if Input.is_action_pressed("press"):
			direction = curr_mouse_pos - global_position
			velocity = direction * DRAG_SPEED
			sprite.play("angry")
			
			if movement.length() > shake_threshold:
				var angle = movement.angle()
				var previous_movement = previous_mouse_position - get_global_mouse_position()
				
				if direction_changes == 0 or sign(angle) != sign(previous_movement.angle()):
					direction_changes += 1
					
					if laid_egg and not animation.is_playing() and Input.is_action_pressed("press"):
						animation.play("fade_out")
				
				if direction_changes == max_direction_changes:
					spawn_egg()
					await get_tree().create_timer(1.0).timeout
					laid_egg = true
					
		if Input.is_action_just_released("press"):
			Interaction_Manager.is_dragging = false
			unhand_me()
	
	else:
		direction = position.direction_to(hotspot)
		if direction and abs(position - hotspot) > Vector2(2, 2):
			sprite.play("walk")
			velocity = direction * speed
		elif will_rest:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.y = move_toward(velocity.y, 0, speed)
			sprite.play("idle")
		elif not will_rest:
			roam()
	
	move_and_slide()

func get_new_pos():
	var neg_x = -roam_dist.x + origin.x
	var pos_x = roam_dist.x + origin.x
	var neg_y = -roam_dist.y + origin.y
	var pos_y = roam_dist.y + origin.y
	hotspot.x = rng.randf_range(neg_x, pos_x)
	hotspot.y = rng.randf_range(neg_y, pos_y)

func roam():
	rest_timer.stop()
	get_new_pos()
	walk_timer.start(rng.randf_range(1.0,3.0))

func rest():
	if will_rest:
		walk_timer.stop()
		hotspot = position
		direction = Vector2.ZERO
		rest_timer.start(rng.randf_range(1.0,3.0))
	else:
		walk_timer.stop()
		roam()

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
	SoundManager.play_sound(self, "15-Chicken_EggDrop")

func register_clickable():
	draggable = true
	scale = Vector2(1.2, 1.2)
	previous_mouse_position = get_global_mouse_position()

func _on_rest_timeout() -> void:
	roam()

func _on_walk_timeout() -> void:
	rest()

func _on_area_2d_mouse_entered() -> void:
	if not Interaction_Manager.is_dragging and clickable:
		Gameplay_Manager.add_hovered(self)

func _on_area_2d_mouse_exited() -> void:
	if Gameplay_Manager.hovered_items.has(self):
		Gameplay_Manager.hovered_items.pop_back()
		unhand_me()
