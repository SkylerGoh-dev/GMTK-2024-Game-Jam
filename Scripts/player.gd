extends CharacterBody2D

@export var speed : int = 100
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction = Vector2.ZERO
var animatedDirection: String = "Down"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var got_hit: Timer = $Hitbox/GotHit
@onready var knife: Area2D = $Weapon/Knife

@export var inventoryResource: InventoryResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if velocity.length() != 0:
		animatedDirection = "down"
		if velocity.x < 0: animatedDirection = "left"
		elif velocity.x > 0: animatedDirection = "right"
		elif velocity.y < 0: animatedDirection = "up"
			
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
	if velocity == Vector2.ZERO:
		sprite.play("Idle")
	else:
		sprite.play("Run")
		
	move_and_slide()
	swingWeapon()

func swingWeapon():
	if Input.is_action_just_pressed("attack"):
		animation_player.play("attack" + animatedDirection)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		area.collect(inventoryResource)
	else:
		knife.set_deferred("monitorable", false)
		speed = 25
		got_hit.start()
		knife.hide()
	
func _on_got_hit_timeout() -> void:
	speed = 100
	knife.show()
	knife.set_deferred("monitorable", true)


func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/cow_level.tscn")
