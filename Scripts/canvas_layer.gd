extends CanvasLayer

@onready var inventory: Control = $Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.close()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("inventory") or event.is_action_pressed("esc"):
		if inventory.isOpen:
			inventory.close()
			Gameplay_Manager.shopping_list.show()
		elif event.is_action_pressed("inventory"):
			inventory.open()
			Gameplay_Manager.inventory_open = true
			Gameplay_Manager.shopping_list.hide()

func _on_inventory_closed() -> void:
	get_tree().paused = false

func _on_inventory_opened() -> void:
	get_tree().paused = true
