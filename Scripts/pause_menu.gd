extends CanvasLayer

func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		show()

func resume():
	get_tree().paused = false
	hide()

func _on_resume_pressed() -> void:
	resume()
