extends Node

class_name SoundManager

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# Use: SoundManager.play_sound(self, "06-PickUp_Item")
static func play_sound(parent: Node, sound_path: String):
	var path = "res://Sounds/" + sound_path + ".wav"
	var sound_stream = ResourceLoader.load(path)
	if sound_stream:
		var sound = AudioStreamPlayer.new()
		sound.stream = sound_stream
		parent.add_child(sound) 
		sound.play()
	else:
		print("Error: Failed to load sound from path: " + sound_path)
