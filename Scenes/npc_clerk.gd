extends StaticBody2D

@onready var interaction_area: Interaction_Area = $Interaction_Area
@onready var label: Label = $Label
var current_dialog : int = 0

var dialog: Array = [
	"Fuck off kid"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	label.hide()

func _on_interact():
	label.show()
	if current_dialog < dialog.size():
		label.text = dialog[current_dialog]
		current_dialog+= 1
		
