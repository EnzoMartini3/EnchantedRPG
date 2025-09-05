extends Panel

onready var overlay: Sprite = $Overlay
onready var slotItem: Sprite = $CenterContainer/Panel/SlottedItem

func itemShift(item: InventoryItem):
	if item:
		overlay.frame = 1
		slotItem.visible = true
		slotItem.texture = item.texture
	else:
		overlay.frame = 0
		slotItem.visible = false
