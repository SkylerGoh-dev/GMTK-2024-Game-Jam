class_name Depot
extends StaticBody2D

@export var type: Resource_Name.type 
@onready var interaction_area: Interaction_Area = $Interaction_Area
@export var item_needed: bool
const ITEM_INDICATOR = preload("res://Scenes/Item_Indicator.tscn")
const indicator_offset :int = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	if item_needed:
		var instance = ITEM_INDICATOR.instantiate()
		instance.global_position = instance.global_position - Vector2(0,indicator_offset)
		instance.play("default")
		add_child(instance)

func _on_interact():
	print("Received ", type)
	
	## Loads in inventory resource and item .tres file
	var inventoryResource: InventoryResource = load("res://InventoryThings/playerInventory.tres")
	var stringNameOfType = Resource_Name.type.keys()[type].to_lower()
	var fullPath = "res://InventoryThings/" + stringNameOfType + ".tres"
	var itemResource: InventoryItem = load(fullPath)
	inventoryResource.insert(itemResource)
