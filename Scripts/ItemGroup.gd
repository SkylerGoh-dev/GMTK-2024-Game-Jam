class_name item_group
extends Node2D

func _ready():
	for depot : Depot in self.get_children():
		depot.type_done.connect(hide_indicator_for_type)
	
func hide_indicator_for_type(type: Resource_Name.type):
	for depots: Depot in self.get_children():
		if depots.type == type:
			depots.hide_indicator()
