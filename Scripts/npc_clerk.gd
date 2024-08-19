class_name clerk
extends StaticBody2D

@onready var interaction_area: Interaction_Area = $Interaction_Area
var current_dialog : int = 1
@onready var panel: Sprite2D = $panel
var panel_open: bool = false
var close_timer: Timer
@onready var item_indicator: AnimatedSprite2D = $Item_Indicator

@export var dialog: Array = [
	"Thank you, come again! \n Please exit to your left or right",
]

@export var dialog_indicator: bool 

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	Gameplay_Manager.npc_clerk = self
	if dialog_indicator:
		show_indicator()

func _process(_delta: float) -> void:
	if panel_open and close_timer == null:
		close_timer = Timer.new()
		add_child(close_timer)
		close_timer.wait_time = 5.0
		close_timer.one_shot = true
		close_timer.start()
		close_timer.timeout.connect(_close_panel)

func _on_interact():
	if close_timer != null:
		close_timer.start()
	if Gameplay_Manager.are_items_collected():
		open_panel()
		panel.get_child(0).text = dialog[0]
		item_indicator.hide()
	elif current_dialog < dialog.size():
		open_panel()
		panel.get_child(0).text = dialog[current_dialog]
		current_dialog+= 1
		if current_dialog >= dialog.size():
			item_indicator.hide()
			# hard code event omegalul
			if get_tree().current_scene.name == "Main6":
				print("Hi")
				Interaction_Manager.player.knife.show()
	elif dialog.size() > 1:
		open_panel()
		panel.get_child(0).text = dialog[dialog.size()-1]

func open_panel() -> void:
	if not panel_open:
		var tween = get_tree().create_tween()
		tween.tween_property(panel,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_SPRING)
		panel_open = true

func _close_panel():
	print("hi")
	panel_open = false
	panel.scale = Vector2(0,0)
	close_timer.queue_free()
	close_timer = null

func show_indicator():
	item_indicator.show()
	item_indicator.play("default")
