extends Area2D

@export var itemResource: InventoryItem

func collect(inventoryResource: InventoryResource):
	inventoryResource.insert(itemResource)
	queue_free()
