extends CharacterBody2D

var health = 210
@export var target: CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var speed = 1.5
var motion = Vector2()
@onready var grandma: CharacterBody2D = $"."
@onready var left: RayCast2D = $"../Player/Left"
@onready var right: RayCast2D = $"../Player/Right"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var godMode = false
@onready var timer: Timer = $Timer
var wonGame = false
@onready var timer_2: Timer = $Timer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var player = get_parent().get_node("Player")
	if player.position.x <= -209:
		player.position.x = -103
		player.position.y = 6
	elif player.position.x >= 1:
		player.position.x = -103
		player.position.y = 6
	elif player.position.y <= -145:
		player.position.x = -103
		player.position.y = 6
	elif player.position.y >= 129:
		player.position.x = -103
		player.position.y = 6
	
	if player.position.x >= -205 and player.position.x <= -179 and player.position.y <= 13 and player.position.y >= -22:
		player.position.x = -103
		player.position.y = 6
	
	#print(animated_sprite_2d.animation)
	if wonGame == false:
		var motion = Vector2()
		player = get_parent().get_node("Player")
		motion += (Vector2(player.position) - position)
		#look_at(player.position)
		if global_position[0] - player.position[0] > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		motion = motion.normalized()*speed
		move_and_collide(motion)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if wonGame == false:
		if "bullet" in body.name:
			health -= 10
			if godMode == false:
				animated_sprite_2d.play("hurt")
				#SoundManager.play_sound(self, "GrandmaHurt")
			else:
				animated_sprite_2d.play("godmodehurt")
				#SoundManager.play_sound(self, "GrandmaHurt")
			timer.start()
			print(health)
			body.queue_free()
		#print(health)
		if godMode == false and health <= 10:
			turnOnGodMode()
	if health == 0 and wonGame == false:
		#print("DIED")
		animated_sprite_2d.pause()
		wonGame = true
		animated_sprite_2d.play("Death")
		SoundManager.play_sound(self, "GrandmaNewDeath")
		timer_2.start()
		#print("Deathplay")
		#_on_animated_sprite_2d_animation_finished()
		#Gameplay_Manager.win_game = true
		#queue_free()

func _on_player_hit_by_grandma() -> void:
	if wonGame == false:
		if godMode == false:
			animated_sprite_2d.play("Rage")
		else:
			animated_sprite_2d.play("godmode")
		var player = get_parent().get_node("Player")
		speed = 0
		#if global_position.x > player.position.x:
			#var tweenie = get_tree().create_tween()
			#tweenie.set_trans(Tween.TRANS_EXPO)
			#var pushBack = Vector2(player.position.x - 50, player.position.y)
			#tweenie.tween_property(player, "position", pushBack, 0.5)
		#else:
			#var tweenie = get_tree().create_tween()
			#tweenie.set_trans(Tween.TRANS_EXPO)
			#var pushBack = Vector2(player.position.x + 50, player.position.y)
			#tweenie.tween_property(player, "position", pushBack, 0.5)
		#await get_tree().create_timer(1.5).timeout
		#speed = 1.5
		var collision_point
		var distance
		var tweenie = get_tree().create_tween()
		#if(left.get_collider()):
			#print(left.get_collider())
			#print(left.get_collider().global_position)
			#collision_point = left.get_collision_point()
			#distance = (player.global_position - collision_point).length()
			#print(collision_point)
			#print(distance)
		
		if global_position.x > player.position.x:
			#tweenie.set_trans(Tween.TRANS_EXPO)
			#var pushBack = Vector2(player.position.x - distance, player.position.y)
			#tweenie.tween_property(player, "position", pushBack, 0.5)
			if(left.get_collider()):
				collision_point = left.get_collision_point()
				distance = (player.global_position - collision_point).length()
				tweenLeft(tweenie, player, distance)
			else:
				tweenLeft(tweenie, player, 50)
		else:
			if(right.get_collider()):
				collision_point = right.get_collision_point()
				distance = (player.global_position - collision_point).length()
				tweenRight(tweenie, player, distance)
			else:
				tweenRight(tweenie, player, 50)
		grandma.set_collision_layer_value(3, false)
		if godMode == false:
			await get_tree().create_timer(1.5).timeout
			speed = 1.5
			SoundManager.play_sound(self, "GrandmaNewCharge")
		elif godMode == true:
			await get_tree().create_timer(3).timeout
			speed = 10
			SoundManager.play_sound(self, "GrandmaNewSuper")
		if (animated_sprite_2d.animation != "Death"):
			if godMode == false:
				animated_sprite_2d.play("Idle")
			else:
				animated_sprite_2d.play("godmode")
		grandma.set_collision_layer_value(3, true)

func tweenLeft(tweenie, player, distance):
	if wonGame == false:
		#print("left", distance)
		tweenie = get_tree().create_tween()
		tweenie.set_trans(Tween.TRANS_EXPO)
		var pushBack = Vector2(player.position.x - distance, player.position.y)
		tweenie.tween_property(player, "position", pushBack, 0.5)
		if distance <= 4.2:
			if godMode == false:
				position.x = position.x + 8
			else:
				position.x = position.x + 20

func tweenRight(tweenie, player, distance):
	if wonGame == false:
		#print("right", distance)
		tweenie = get_tree().create_tween()
		tweenie.set_trans(Tween.TRANS_EXPO)
		var pushBack = Vector2(player.position.x + distance, player.position.y)
		tweenie.tween_property(player, "position", pushBack, 0.5)
		if distance <= 4.2:
			if godMode == false:
				position.x = position.x - 8
			else:
				position.x = position.x - 20

func turnOnGodMode():
	if wonGame == false:
		if godMode == false:
			SoundManager.play_sound(self, "GrandmaNewSuper")
			health = 200
			speed = 10
			godMode = true

func _on_timer_timeout() -> void:
	if wonGame == false:
		if godMode == false:
			animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("godmode")
		#print("bruh")


func _on_animated_sprite_2d_animation_finished() -> void:
	#print("ASGIASGMASIJGNASIJGN")
	#print("wonGame", wonGame)
	if wonGame == true:
		Gameplay_Manager.win_game = true
		queue_free()
		#print("testsssd")


func _on_timer_2_timeout() -> void:
	if wonGame == true:
		Gameplay_Manager.win_game = true
		queue_free()
		#print("testsssd")
