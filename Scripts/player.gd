extends CharacterBody2D

@export var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	velocity = Input.get_vector("left", "right", "up", "down") * speed
	move_and_slide()
