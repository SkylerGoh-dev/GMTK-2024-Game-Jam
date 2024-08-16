extends CharacterBody2D

@export var speed : int = 100
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(_delta):
	velocity = Input.get_vector("left", "right", "up", "down") * speed
	
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
	if velocity == Vector2.ZERO:
		sprite.play("Idle")
	else:
		sprite.play("Run")
		
	move_and_slide()
	
