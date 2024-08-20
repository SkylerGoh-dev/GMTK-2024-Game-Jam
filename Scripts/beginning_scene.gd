extends Node2D

@onready var camera_1: Camera2D = $Camera1
@onready var camera_2: Camera2D = $Camera2
@onready var remote_transform_2d: RemoteTransform2D = $Player/RemoteTransform2D
@onready var main_camera: Camera2D = $MainCamera
const TWEEN_DURATION: int = 1
@onready var main_menu_buttons: Control = $CanvasLayer/MainMenuButtons
@onready var play_label: Label = $CanvasLayer/MainMenuButtons/VBoxContainer2/Play/PlayLabel
@onready var quit_label: Label = $CanvasLayer/MainMenuButtons/VBoxContainer2/Quit/QuitLabel
@onready var interaction_area: Interaction_Area = $Interaction_Area
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_camera.make_current()
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	print("interacting")
	get_tree().change_scene_to_file("res://Scenes/levels/main.tscn")
	Gameplay_Manager.current_week = 1

func move_label(label: Label, direction):
	if direction == "UP":
		label.position.y = -15
	elif direction == "DOWN":
		label.position.y = 15
		

func transition_camera():
	var tween : Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(main_camera, "zoom", camera_2.zoom, TWEEN_DURATION)
	tween.tween_property(main_camera, "global_position", camera_2.global_position, TWEEN_DURATION)
	await tween.finished
	camera_2.make_current()
	player.playable = true

func _on_play_pressed() -> void:
	transition_camera()
	main_menu_buttons.hide()

func _on_play_button_up() -> void:
	move_label(play_label, "UP")


func _on_play_button_down() -> void:
	move_label(play_label, "DOWN")


func _on_quit_button_down() -> void:
	move_label(quit_label, "DOWN")


func _on_quit_button_up() -> void:
	move_label(quit_label, "UP")


func _on_quit_pressed() -> void:
	get_tree().quit()
