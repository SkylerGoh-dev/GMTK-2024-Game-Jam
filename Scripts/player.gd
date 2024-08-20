extends CharacterBody2D

@export var speed : int = 100
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction = Vector2.ZERO
var animatedDirection: String = "Down"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var got_hit: Timer = $Player_Hitbox/GotHit
@onready var knife: Area2D = $Weapon/Knife
@onready var knife_collision: CollisionShape2D = $Weapon/Knife/CollisionShape2D

@export var inventoryResource: InventoryResource

signal hitByGrandma

var knife_disabled: bool = true
var hurt: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Interaction_Manager.player = self
	knife_collision.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	reset_inventory()
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
		
	if not hurt:
		if velocity == Vector2.ZERO:
			sprite.play("Idle")
		else:
			sprite.play("Run")
		
	move_and_slide()
	swingWeapon()

func swingWeapon():
	if Input.is_action_just_pressed("attack") and not knife_disabled:
		knife_collision.disabled = false
		animation_player.play("attack" + animatedDirection)
		if not knife_disabled:
			SoundManager.play_sound(self, "19-Swing_Knife")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		area.collect(inventoryResource)
	else:
		sprite.play("hurt")
		hurt = true
		#$Weapon/Knife.hide()
		knife.set_deferred("monitorable", false)
		speed = 25
		got_hit.start()
		knife.hide()
		SoundManager.play_sound(self, "20-Human_Hurt")
	
func _on_got_hit_timeout() -> void:
	speed = 100
	hurt = false
	knife.set_deferred("monitorable", true)
	if not knife_disabled:
		knife.show()

func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/cow_level.tscn")

#func _on_timer_timeout() -> void:
	#get_tree().change_scene_to_file("res://Scenes/levels/cow_level.tscn")

func reset_inventory():
	if Input.is_action_just_pressed("reset inventory"):
		inventoryResource.clearAll()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	knife_collision.disabled = true
	
func set_knife_disabled(value: bool):
	knife_disabled = value


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if "grandma" in body.name:
		sprite.play("hurt")
		SoundManager.play_sound(self, "20-Human_Hurt")
		hurt = true
		speed = 25
		got_hit.start()
		hitByGrandma.emit()
