extends CanvasLayer

func _on_button_pressed() -> void:
	queue_free()


func _on_button_mouse_entered() -> void:
	$Button.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)
	print('hi')


func _on_button_mouse_exited() -> void:
	$Button.set_default_cursor_shape(Control.CURSOR_ARROW)
