extends Node2D

var clickable : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if clickable and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		queue_free()
		#collect(inventoryResource)

#func collect(inventoryResource: InventoryResource):
	#inventoryResource.insert(itemResource)
	#queue_free()


func _on_area_2d_mouse_entered() -> void:
	if clickable:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_2d_mouse_exited() -> void:
	if clickable:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
