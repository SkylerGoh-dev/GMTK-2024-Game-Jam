extends Node2D

var load_done : bool = false
var level_path : String
@onready var dialog: Label = $CanvasLayer/Dialog

func _ready() -> void:
	dialog.text = Gameplay_Manager.get_dialog()
	level_path = Gameplay_Manager.next_level_path()
	load_done = false
	ResourceLoader.load_threaded_request(level_path)

func _process(delta):
	var progress = []
	ResourceLoader.load_threaded_get_status(level_path,progress)
	if progress[0] == 1:
		load_done = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and load_done:
			var packedscene = ResourceLoader.load_threaded_get(level_path)
			get_tree().change_scene_to_packed(packedscene)