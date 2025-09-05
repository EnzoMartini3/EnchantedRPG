extends Resource
class_name Inventory

export var items: Array = [InventoryItem]
signal inventoryChanged

func insertItem(item: InventoryItem):
	for i in range(items.size()):
		if !items[i]:
			items[i] = item
			break
	emit_signal("inventoryChanged")
