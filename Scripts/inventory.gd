extends Control

signal opened
signal closed

var isOpen: bool = false

@onready var inventoryResource: InventoryResource = preload("res://InventoryThings/playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	inventoryResource.updated.connect(update)
	update()

func update():
	print(inventoryResource.slots)
	for i in range(min(inventoryResource.slots.size(), slots.size())):
		print(inventoryResource)
		slots[i].update(inventoryResource.slots[i])

func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()
