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
		else:
			inventory.open()

func _on_inventory_closed() -> void:
	get_tree().paused = false


func _on_inventory_opened() -> void:
	get_tree().paused = true
