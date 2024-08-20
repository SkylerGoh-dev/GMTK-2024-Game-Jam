extends Node2D

var clickable : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if clickable and Input.is_action_just_pressed("press"):
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		collect(get_parent().inventoryResource)

func collect(inventoryResource: InventoryResource):
	inventoryResource.insert(get_parent().itemResource)
	queue_free()


func _on_area_2d_mouse_entered() -> void:
	if clickable:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_2d_mouse_exited() -> void:
	if clickable:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
