extends Resource
class_name Inventory

signal itemsChanged(indexes)   #indexes é um array

var dragData = null
var isOpen = false

export(Array, Resource) var items = [
	null, null, null, null, null, null, null, null, null
]

func setItem(itemIndex, thisItem):
	var previousItem = items[itemIndex]      #guardamos o item que estava ali
	items[itemIndex] = thisItem
	emit_signal("itemsChanged", [itemIndex])
	return previousItem

func swapItems(itemIndex, targetItemIndex):
	var targetItem = items[targetItemIndex]
	var itemOnHands = items[itemIndex]
	items[targetItemIndex] = itemOnHands
	items[itemIndex] = targetItem
	emit_signal("itemsChanged", [itemIndex, targetItemIndex])

func removeItem(itemIndex):
	var previousItem = items[itemIndex]
	items[itemIndex] = null
	emit_signal("itemsChanged", [itemIndex])
	return previousItem

func singularize():          #passa por todos os itens do inventário e os torna únicos (conserta bugs e melhora o funcionamento em geral)
	var uniqueItems = []
	for item in items:
		if item is Item:                           #se houver um item ali,
			uniqueItems.append(item.duplicate())   #adicione ao novo array
		else:
			uniqueItems.append(null)               #adicionamos também os espaços vazios pra refletir perfeitamente 
	items = uniqueItems                            #reescrevemos o inventário inteiro
