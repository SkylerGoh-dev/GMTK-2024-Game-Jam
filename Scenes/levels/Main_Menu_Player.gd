extends CharacterBody2D


const SPEED = 300.0
var direction: Vector2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var playable: bool = false

func _physics_process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
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
