extends Area2D

@export var itemResource: InventoryItem

func _ready():
	Gameplay_Manager._register_item(20,1)
	Gameplay_Manager._register_item(14,1)

func collect(inventoryResource: InventoryResource):
	inventoryResource.insert(itemResource)
	queue_free()
