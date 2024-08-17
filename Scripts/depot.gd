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
