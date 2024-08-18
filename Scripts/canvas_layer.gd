extends CanvasLayer

@onready var inventory: Control = $Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.close()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("inventory"):
		if inventory.isOpen:
			inventory.close()
			Gameplay_Manager.shopping_list.hide()
		else:
			inventory.open()
			Gameplay_Manager.shopping_list.show()

func _on_inventory_closed() -> void:
	get_tree().paused = false


func _on_inventory_opened() -> void:
	get_tree().paused = true
