extends Resource

class_name InventoryResource

signal updated

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	for slot in slots:
		if slot.item == item:
			slot.amount += 1
			updated.emit()
			return
			
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].amount = 1
			updated.emit()
			return
