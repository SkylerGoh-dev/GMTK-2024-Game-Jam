extends CharacterBody2D

const SPEED = 50.0
const GRAVITY = 200.0
const FRICTION = 0.5  # Make sure this is a float by adding .0

var inside = false

var previous_mouse_position: Vector2 = Vector2.ZERO
var current_mouse_position: Vector2 = Vector2.ZERO

@export var napkin_manager: NodePath

func _ready() -> void:
	var manager = get_node(napkin_manager)
	if manager:
		manager.add_napkin(self)

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta

	if is_on_floor():
		# Apply friction to slow down sliding
		velocity.x = lerp(velocity.x, 0.0, FRICTION * delta)
		
	move_and_slide()

	if Input.is_action_just_released("press"):
		if inside: #and is_on_floor()
			# ADD Napkin to Inventory====================================
			print("Added Napkin")
			#SOUND: Item Collected
			queue_free()

	previous_mouse_position = current_mouse_position

func _on_area_2d_mouse_entered() -> void:
	#CHECK for isInSIDE STATIC VARIABLE FROM napkin_box... HELP HERE
	if not napkin_box.isInside:
		scale = Vector2(1.3, 1.3)
		inside = true

func _on_area_2d_mouse_exited() -> void:
	scale = Vector2(1, 1)
	inside = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	var manager = get_node(napkin_manager)
	if manager:
		manager.remove_napkin(self)
