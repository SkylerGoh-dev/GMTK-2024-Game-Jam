extends CharacterBody2D


const SPEED = 100.0
var direction: float
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var playable: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	direction = Input.get_axis("left", "right")
	velocity.x = direction * SPEED
	if playable:		
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true

		if velocity == Vector2.ZERO:
			sprite.play("default")
		else:
			sprite.play("run")
		move_and_slide()

#do not remove for main menu with interaction area 
# bad coding happening rn
func swingWeapon():
	pass
