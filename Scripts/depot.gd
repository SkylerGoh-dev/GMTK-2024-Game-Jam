class_name Depot
extends StaticBody2D

@export var type: Resource_Name.type 
@onready var interaction_area: Interaction_Area = $Interaction_Area

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	print("Received ", type)
	
	## Loads in inventory resource and item .tres file
	var inventoryResource: InventoryResource = load("res://InventoryThings/playerInventory.tres")
	var stringNameOfType = Resource_Name.type.keys()[type].to_lower()
	var fullPath = "res://InventoryThings/" + stringNameOfType + ".tres"
	var itemResource: InventoryItem = load(fullPath)
	inventoryResource.insert(itemResource)
