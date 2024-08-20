extends CharacterBody2D

var speed = 300

func _process(delta):
	var forward_direction = Vector2(0, -1).rotated(rotation)
	position += forward_direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("gone")
	queue_free()
