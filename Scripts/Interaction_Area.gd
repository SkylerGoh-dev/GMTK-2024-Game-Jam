class_name Interaction_Area
extends Area2D

# Callable function for variable interactions
var interact: Callable = func():
	pass

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		body_entered.connect(_on_body_entered)
	if not is_connected("body_exited", _on_body_exited):
		body_exited.connect(_on_body_exited)
# When player enters the interaction area, register area to interaction manager
# This registers interaction area, as a possible interactable when player gets close
func _on_body_entered(body):
	if body.has_method("swingWeapon"):
		Interaction_Manager.register_area(self)

# When player exits the interaction area, unregister it
# Does not allow player to interact if not in area
func _on_body_exited(body):
	if body.has_method("swingWeapon"):
		Interaction_Manager.unregister_area(self)

func collectHooked(hookedObject):
	await get_tree().create_timer(0.75).timeout
	#print("brooo")
	#print(get_overlapping_bodies()[1])
	#print(hookedObject)
	if(get_overlapping_bodies().size() > 1):
		for body in get_overlapping_bodies():
			if body.name == "Player":
				return true
		#if(get_overlapping_bodies()[1].name == "Player"):
			###print("breh")
			##get_parent().queue_free()
			#return true
