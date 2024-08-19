extends StaticBody2D

func _on_rope_line_hooked(hooked_position: Variant) -> void:
	await get_tree().create_timer(0.2).timeout
	var tween = get_tree().create_tween()	
	print(hooked_position)
	tween.tween_property(self, "position", hooked_position, 0.75)
