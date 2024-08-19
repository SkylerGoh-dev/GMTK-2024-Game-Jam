extends Node2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var active_areas: Array = []
var can_interact: bool = true
var is_dragging: bool = false

func register_area(area: Interaction_Area):
	active_areas.push_back(area)
	#print("add", area)
	
func unregister_area(area: Interaction_Area):
	var index = active_areas.find(area)
	#print("clear", area)
	if index != -1:
		active_areas.remove_at(index)
	#print(active_areas)

# Actively sort interaction areas by distance
func _process(_delta):
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		
func _sort_by_distance_to_player(area1: Area2D, area2: Area2D):
	var dist1 = player.global_position.distance_to(area1.global_position)
	var dist2 = player.global_position.distance_to(area2.global_position)
	return dist1 < dist2

# If interact button pushed interact with closest interaction area
func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			await active_areas[0].interact.call()
			can_interact = true

func clear_areas():
	active_areas.clear()
