extends Resource

class_name InventoryResource

signal updated

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	for slot in slots:
		if slot.item == item:
			slot.amount += 1
			updated.emit()
			Gameplay_Manager.update_item_completion(item.name,slot.amount)
			return
			
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].amount = 1
			Gameplay_Manager.update_item_completion(item.name,1)
			updated.emit()
			return

func clearAll():
	for slot in slots:
		slot.item = null
		slot.amount = 0
	updated.emit()
