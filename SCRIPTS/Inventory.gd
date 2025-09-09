extends Resource
class_name Inventory

export var slots: Array = [InventoryItem]
signal inventoryChanged

# LEMBRETE: COMENTEI A FUNCAO ITEMSHIFT NO INVENTORY HUD PQ NAO TAVA RECEBEDNDO A VARIAVEL ITEM. NAO SEI OQ ACONTECEU NESSA AQUI PQ ELA NAO ACHA O ITEM TBM MAS RECEBE NA FUNCAO, TALVEZ O PROBLEMA SEJA COMO ELA RECEBE.

func insertItem(item: InventoryItem):
#	for slot in slots:
#		if slot.item == item:
#			slot.amount += 1
#			emit_signal("inventoryChanged")
#			return
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i] = item
			slots[i].amount = 1
			emit_signal("inventoryChanged")
			return
