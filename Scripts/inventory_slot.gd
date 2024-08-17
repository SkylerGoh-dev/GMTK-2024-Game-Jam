extends Panel

@onready var backgroundSprite: Sprite2D = $Sprite2D
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/Item

func update(item: InventoryItem):
	if !item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = item.texture
