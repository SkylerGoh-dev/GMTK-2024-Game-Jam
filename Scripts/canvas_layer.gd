extends CanvasLayer

@onready var inventory: Control = $Inventory

var panel_open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.close()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func _input(event):
	if (event.is_action_pressed("inventory") or event.is_action_pressed("esc")) and not panel_open:
		if inventory.isOpen:
			inventory.close()
			Gameplay_Manager.shopping_list.show()
			if event.is_action_pressed("inventory"):
				Gameplay_Manager.inventory_open = false
		elif event.is_action_pressed("inventory"):
			inventory.open()
			Gameplay_Manager.shopping_list.hide()

func hide_ui():
	Gameplay_Manager.shopping_list.hide()
	inventory.hide()
	panel_open = true

func show_ui():
	Gameplay_Manager.shopping_list.show()
	panel_open = false

func _on_inventory_closed() -> void:
	get_tree().paused = false

func _on_inventory_opened() -> void:
	get_tree().paused = true
	Gameplay_Manager.inventory_open = true

func _on_chicken_pen_chicken_game_opened() -> void:
	hide_ui()

func _on_chicken_game_chicken_game_closed() -> void:
	show_ui()
