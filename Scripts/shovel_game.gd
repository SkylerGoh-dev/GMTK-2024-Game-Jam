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
var let_start : bool = true
var done_diggin : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Gameplay_Manager._register_item(Resource_Name.type["MANURE"],1)
	#visible = false
	manure.visible = false
	manure.position = Vector2(4, 25)
	manure.scale = Vector2(1,1)
	background.frame = 0
	reset_arrow()
	update_bar()

func _process(_delta) -> void:
	if animation.is_playing() and animation.current_animation != 'charge':
		return
	
	if Input.is_action_just_pressed("interact") and level < 3:
		if not started:
			start_game()
		elif started and arrow.position.x > left and arrow.position.x < right:
			successful_dig()
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
	arrow.position.x = -32
	direction = 1

func reset_game():
	started = false
	reset_arrow()

func successful_dig():
	animation.play("dig")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"rest":
			start_game()
		"dig":
			level += 1
			background.set_deferred("frame", level)
			reset_arrow()
			if level < 3:
				update_bar()
				animation.play("rest")
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
			done_diggin = true
			manure.position = Vector2(40, -4)
			manure.scale = Vector2(1.75, 1.75)
			animation.play("RESET")
		"fail":
			reset_arrow()
			animation.play("RESET")
		"RESET":
			if not done_diggin:
				start_game()


func _on_button_pressed() -> void:
	visible = false
	if not animation.current_animation == "reveal":
		get_parent().show_ui()
		animation.stop()
		reset_game()

func _on_button_mouse_entered() -> void:
	$Button.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)

func _on_button_mouse_exited() -> void:
	$Button.set_default_cursor_shape(Control.CURSOR_ARROW)
