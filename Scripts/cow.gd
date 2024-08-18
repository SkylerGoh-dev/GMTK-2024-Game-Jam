extends CharacterBody2D

@export var target: CharacterBody2D
@onready var charge: Timer = $Charge
@onready var attack_time: Timer = $AttackTime
@onready var beef = preload("res://Scenes/beef.tscn")

var speed = 50
var direction = Vector2.ZERO
var randie = randf_range(-0.3, 0.3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = position.direction_to(target.position)
	randie = randf_range(-0.3, 0.3)
	direction[0] += randie
	direction[1] += randie
	charge.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	if target:
		velocity = direction * speed
	move_and_slide()

func _on_charge_timeout() -> void:
	attack_time.start()
	speed = 0

func _on_attack_time_timeout() -> void:
	direction = position.direction_to(target.position)
	randie = randf_range(-0.3, 0.3)
	direction[0] += randie
	direction[1] += randie
	charge.start()
	speed = 150

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var beefInstance = beef.instantiate()
	beefInstance.global_position = global_position
	get_parent().add_child(beefInstance)
	queue_free()
