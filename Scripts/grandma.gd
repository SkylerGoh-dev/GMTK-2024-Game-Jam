extends CharacterBody2D

var health = 200
@export var target: CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var speed = 1.5
var motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var motion = Vector2()
	var player = get_parent().get_node("Player")
	motion += (Vector2(player.position) - position)
	#look_at(player.position)
	if global_position[0] - player.position[0] > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	motion = motion.normalized()*speed
	move_and_collide(motion)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "bullet" in body.name:
		health -= 10
		body.queue_free()
	#print(health)
	if health <= 0:
		queue_free()

func _on_player_hit_by_grandma() -> void:
	var player = get_parent().get_node("Player")
	speed = 0
	if global_position.x > player.position.x:
		var tweenie = get_tree().create_tween()
		tweenie.set_trans(Tween.TRANS_EXPO)
		var pushBack = Vector2(player.position.x - 50, player.position.y)
		tweenie.tween_property(player, "position", pushBack, 0.5)
	else:
		var tweenie = get_tree().create_tween()
		tweenie.set_trans(Tween.TRANS_EXPO)
		var pushBack = Vector2(player.position.x + 50, player.position.y)
		tweenie.tween_property(player, "position", pushBack, 0.5)
	await get_tree().create_timer(1.5).timeout
	speed = 1.5
