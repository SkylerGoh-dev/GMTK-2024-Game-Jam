extends CharacterBody2D

var gravity = 9.8
var friction = 1
var ground = false
var falling = false
var clicker = 0
var clickable = false

@export var itemResource: InventoryItem
@export var inventoryResource: InventoryResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Gameplay_Manager.hovered_items.has(self) and not clickable:
		register_clickable()
	elif (not Gameplay_Manager.hovered_items.has(self)) and clickable:
		unregister_clickable()
	
	velocity.y += gravity
	if velocity.y > 0 and not falling:
		$Timer.start()
		falling = true
	
	if ground:
		velocity.x = move_toward(velocity.x, 0, 3 * friction)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		
	move_and_slide()

func collect(inventoryResource: InventoryResource):
	inventoryResource.insert(itemResource)
	queue_free()

func register_clickable():
	clickable = true
	scale = Vector2(1, 1)
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func unregister_clickable():
	clickable = false
	scale = Vector2(0.7, 0.7)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_timer_timeout() -> void:
	gravity = 0
	velocity.y = 0
	ground = true

func _on_area_2d_mouse_entered() -> void:
	Gameplay_Manager.add_hovered(self)
	

func _on_area_2d_mouse_exited() -> void:
	if Gameplay_Manager.hovered_items.has(self):
		Gameplay_Manager.hovered_items.pop_front()
	scale = Vector2(0.7, 0.7)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("press") and clickable:
		clicker = min(2, clicker + 1)
		if clicker == 1:
			collect(inventoryResource)
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
