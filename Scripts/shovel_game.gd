extends Control

@export var itemResource: InventoryItem
@export var inventoryResource: InventoryResource

@onready var background = $AnimatedSprite2D
@onready var animation = $AnimationPlayer
@onready var under = $Progress/Under
@onready var good = $Progress/Good
@onready var over = $Progress/Over
@onready var arrow = $Arrow
@onready var manure = $Manure

var level : int = 0
var left : int
var right : int
var started : bool = false
var direction : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Gameplay_Manager._register_item(Resource_Name.type["MANURE"],1)
	#visible = false
	manure.visible = false
	background.frame = 0
	reset_arrow()
	update_bar()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and level < 3:
		if not started and level == 0:
			start_game()
		elif started and arrow.position.x > left and arrow.position.x < right:
			successful_dig()
			started = false
		elif started and (arrow.position.x < left or arrow.position.x > right):
			animation.play("fail")
			

func update_bar():
	under.custom_minimum_size.x = 30 + level * randi_range(5, 10)
	good.custom_minimum_size.x = 12 - level * randi_range(3,4)
	over.custom_minimum_size.x = 64 - under.custom_minimum_size.x - good.custom_minimum_size.x
	left = -32 + under.custom_minimum_size.x
	right = left + good.custom_minimum_size.x

func start_game():
	started = true
	animation.play("charge")

func reset_arrow():
	started = false
	arrow.position.x = -32
	direction = 1

func successful_dig():
	level += 1
	animation.play("dig")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"dig":
			background.set_deferred("frame", level)
			reset_arrow()
			if level < 3:
				update_bar()
				await get_tree().create_timer(0.5).timeout
				start_game()
			elif level == 3:
				manure.visible = true
				animation.play("reveal")
		"charge":
			direction *= -1
			if direction == 1:
				animation.play("charge")
			elif direction == -1:
				animation.play_backwards("charge")
		"reveal":
			manure.clickable = true
		"fail":
			await get_tree().create_timer(1).timeout
			reset_arrow()
			animation.play("RESET")
		"RESET":
			start_game()


func _on_button_pressed() -> void:
	visible = false

func _on_button_mouse_entered() -> void:
	$Button.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)

func _on_button_mouse_exited() -> void:
	$Button.set_default_cursor_shape(Control.CURSOR_ARROW)
