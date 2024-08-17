extends Control

signal opened
signal closed

var isOpen: bool = false

@onready var inventoryResource: InventoryResource = preload("res://InventoryThings/playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	update()

func update():
	for i in range(min(inventoryResource.items.size(), slots.size())):
		slots[i].update(inventoryResource.items[i])

func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()
