extends Sprite2D

@onready var inventoryResource: InventoryResource = preload("res://InventoryThings/playerInventory.tres")

var hasRope = false

func _process(delta):
	checkForRope()

func checkForRope():
	for slot in inventoryResource.slots:
		if slot.item:
			if slot.item.name == "Rope":
				hasRope = true
				toggle_visibility()

func toggle_visibility():
	if hasRope == true:
		visible = true
