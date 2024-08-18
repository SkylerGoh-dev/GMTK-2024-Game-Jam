extends StaticBody2D

@onready var interaction_area: Interaction_Area = $Interaction_Area
var current_dialog : int = 0
@onready var panel: Sprite2D = $panel
var panel_open: bool = false
var close_timer: Timer

var dialog: Array = [
	"I'm the npc clerk",
	"fuck off kid"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _process(_delta: float) -> void:
	if panel_open and close_timer == null:
		close_timer = Timer.new()
		add_child(close_timer)
		close_timer.wait_time = 8.0
		close_timer.one_shot = true
		close_timer.start()
		close_timer.timeout.connect(_close_panel)

func _on_interact():
	if close_timer != null:
		close_timer.start()
	if not panel_open:
		var tween = get_tree().create_tween()
		tween.tween_property(panel,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_SPRING)
		panel_open = true
	if current_dialog < dialog.size():
		panel.get_child(0).text = dialog[current_dialog]
		current_dialog+= 1

func _close_panel():
	print("hi")
	panel_open = false
	panel.scale = Vector2(0,0)
	close_timer.queue_free()
	close_timer = null
