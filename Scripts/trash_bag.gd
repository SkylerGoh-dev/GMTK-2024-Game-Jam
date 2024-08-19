extends CharacterBody2D
#Napkin
const SPEED = 50.0
const GRAVITY = 200.0
const FRICTION = 0.5  # Make sure this is a float by adding .0

var alreadyDragged = false
var draggable = false
var inside = false

var previous_mouse_position: Vector2 = Vector2.ZERO
var current_mouse_position: Vector2 = Vector2.ZERO

# Reference to the NapkinManager
@export var trash_bag_manager: NodePath

func _ready() -> void:
	var manager = get_node(trash_bag_manager)
	if manager:
		manager.add_trash_bag(self)

func _physics_process(delta: float) -> void:
	if draggable:
		current_mouse_position = get_global_mouse_position()
		global_position = current_mouse_position
	else:
		velocity.y += GRAVITY * delta

		if is_on_floor():
			# Apply friction to slow down sliding
			velocity.x = lerp(velocity.x, 0.0, FRICTION * delta)
			
		move_and_slide()

	if Input.is_action_just_released("press"):
		if not alreadyDragged:
			draggable = false
			alreadyDragged = true
			scale = Vector2(2, 2)
			
			var launch_direction = (current_mouse_position - previous_mouse_position).normalized()
			velocity = launch_direction * SPEED
			velocity.y -= SPEED / 2.0  # Adjust this value to control upward force
		elif inside and is_on_floor():
			# ADD trash_bag to Inventory====================================
			print("Added Trash bag")
			queue_free()

	previous_mouse_position = current_mouse_position

func _on_area_2d_mouse_entered() -> void:
	scale = Vector2(2.3, 2.3)
	if not alreadyDragged:
		if not Interaction_Manager.is_dragging:
			draggable = true
	elif alreadyDragged and is_on_floor():  # Make sure it applies only to dropped napkins
		inside = true

func _on_area_2d_mouse_exited() -> void:
	scale = Vector2(2, 2)
	if not alreadyDragged:
		if not Interaction_Manager.is_dragging:
			draggable = false
			velocity.x = velocity.x / 10.0  # Optional: Slow down more when exiting
	else:
		inside = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	var manager = get_node(trash_bag_manager)
	if manager:
		manager.remove_napkin(self)
