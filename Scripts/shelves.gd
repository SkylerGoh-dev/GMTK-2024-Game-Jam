class_name Shelves
extends Depot

@onready var top_half: Sprite2D = $top_half
@onready var bottom_half: Sprite2D = $bottom_half

var shelf_type = [16,32,48]

func _ready():
	super()
	top_half.region_rect = Rect2i(shelf_type.pick_random(),0,16,16)
	bottom_half.region_rect = Rect2i(shelf_type.pick_random(),16,16,16)
	
