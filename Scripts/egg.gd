extends CharacterBody2D

var gravity = 9.8
var friction = 1
var ground = false
var clickable = false
var falling = false

@export var itemResource: InventoryItem
@export var inventoryResource: InventoryResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += gravity
	if velocity.y > 0 and not falling:
		$Timer.start()
		falling = true
	
	if ground:
		velocity.x = move_toward(velocity.x, 0, 2 * friction)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		
	if clickable:
		if Input.is_action_just_pressed("press"):
			collect(inventoryResource)
	
	move_and_slide()

func collect(inventoryResource: InventoryResource):
	inventoryResource.insert(itemResource)
	queue_free()

func _on_timer_timeout() -> void:
	gravity = 0
	velocity.y = 0
	ground = true

func _on_area_2d_mouse_entered() -> void:
	clickable = true
	scale = Vector2(1, 1)
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited() -> void:
	clickable = false
	scale = Vector2(0.7, 0.7)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
