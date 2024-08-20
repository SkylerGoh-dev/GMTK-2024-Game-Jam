extends Node2D

@export var destination: Marker2D
@onready var interaction_area: Interaction_Area = $Interaction_Area

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	Interaction_Manager.player.global_position = destination.global_position
	SoundManager.play_sound(self, "11-Door_Close")
