extends GridContainer

var inventory = preload("res://Player/Inventory.tres")

func _ready():
	inventory.connect("itemsChanged", self, "_onItemsChanged")
	inventory.singularize()
	updateInventoryDisplay()

func updateInventoryDisplay():
	for itemIndex in inventory.items.size():     #roda por todo o inventário
		updateSlot(itemIndex)

func updateSlot(itemIndex):
	var inventorySlot = get_child(itemIndex)     #obtemos o Slot específico indicado pelo itemIndex
	var item = inventory.items[itemIndex]
	inventorySlot.slotDisplayItem(item)          #chama a função displayItem no slot desejado, e a exibição dele é atualizada

func _onItemsChanged(indexes):    #algum item mudou? vamos atualizar todos os slots.
	for itemIndex in indexes:
		updateSlot(itemIndex)

func _unhandled_input(event):     #se algum item for dropado pra fora do inventário
	if event.is_action_released("ui_m1"):
		if inventory.dragData is Dictionary:
			inventory.setItem(inventory.dragData.itemIndex, inventory.dragData.item)
