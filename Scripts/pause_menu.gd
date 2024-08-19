extends CanvasLayer

@onready var resumeLabel = $Control/VBoxContainer/Resume/ResumeLabel
@onready var restartLabel = $Control/VBoxContainer/Restart/RestartLabel
@onready var quitLabel = $Control/VBoxContainer/Quit/QuitLabel

func resume():
	get_tree().paused = false
	queue_free()

func move_label(label: Label, direction):
	if direction == "UP":
		label.position.y = -15
	elif direction == "DOWN":
		label.position.y = -3

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	#var items = Gameplay_Manager.scene_items
	get_tree().reload_current_scene()
	#Interaction_Manager.clear_areas()
	#Gameplay_Manager.clear_needed_items()
	#for item in items:
		#var upperItem = item.to_upper()
		#var key = Resource_Name.type[upperItem]
		#await Gameplay_Manager._register_item(key, items[item])

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_resume_button_down() -> void:
	move_label(resumeLabel, "DOWN")

func _on_restart_button_down() -> void:
	move_label(restartLabel, "DOWN")

func _on_quit_button_down() -> void:
	move_label(quitLabel, "DOWN")


func _on_resume_button_up() -> void:
	move_label(resumeLabel, "UP")

func _on_restart_button_up() -> void:
	move_label(restartLabel, "UP")

func _on_quit_button_up() -> void:
	move_label(quitLabel, "UP")
