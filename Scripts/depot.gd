class_name Depot
extends StaticBody2D

@export var type: Resource_Name.type 
@onready var interaction_area: Interaction_Area = $Interaction_Area
@export var item_needed: bool
@export var item_amount: int = 1
const ITEM_INDICATOR = preload("res://Scenes/Item_Indicator.tscn")
const indicator_offset :int = 8
var indicator

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	if item_needed:
		indicator = ITEM_INDICATOR.instantiate()
		indicator.global_position = indicator.global_position - Vector2(0,indicator_offset)
		indicator.play("default")
		add_child(indicator)
		#register item is needed for week
		Gameplay_Manager._register_item(type,item_amount)

func _on_interact():
	if item_needed:
		## Loads in inventory resource and item .tres file
		var inventoryResource: InventoryResource = load("res://InventoryThings/playerInventory.tres")
		var stringNameOfType = Resource_Name.type.keys()[type].to_lower()
		var fullPath = "res://InventoryThings/" + stringNameOfType + ".tres"
		var itemResource: InventoryItem = load(fullPath)
		inventoryResource.insert(itemResource)
		
		if Gameplay_Manager.item_finished(stringNameOfType):
			indicator.hide()
