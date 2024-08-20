extends Node2D


@onready var interaction_area: Interaction_Area = $Interaction_Area

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	Gameplay_Manager.end_week()
	
