extends Resource
class_name Inventory

signal itemsChanged(indexes)   #indexes é um array
signal matterChanged(mat, amount)
signal matterUnlocked(mat)

export(Array, Resource) var items = [
	null, null, null, null, null, null, null, null, null
]
export(Resource) var lifelightLily
var unlockedMatter: Dictionary = {
	"Wood": false,
	"Yarn": false,
	"Sand": false,
	"Ore": false,
	"PowerPrism": false
}
var primeMatter: Dictionary = {}
var dragData = null

func lookForSpace(item):
	for i in range(items.size()):
		if items[i] != null && items[i].name == item.name:             #a prioridade é encontrar uma pilha já existente do item a ser inserido
			return i
	for j in range(items.size()):                  #caso o usuário não tenha cópias do item no inventário, procuramos uma posição vazia
		if items[j] == null: 
			return j                               #achamos uma posição e retornamos ela
	return -1                                      #não achamos, então o inventário está cheio


func insertItem(thisItem):
	var freeSpaceIndex = lookForSpace(thisItem)
	if freeSpaceIndex == -1:
		return false
	if items[freeSpaceIndex].name == thisItem.name:
		items[freeSpaceIndex].amount += 1
		emit_signal("itemsChanged", [freeSpaceIndex])
		return true


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


func expendItem(thisItem):
	if thisItem is Usable:
		thisItem.triggerEffect()

func addMatter(thisMatter, amount):
	if not primeMatter.has(thisMatter):            #iniciamos um item ao obter ele
		primeMatter[thisMatter] = 0
	if not unlockedMatter[thisMatter]:             #itemUnlocked = false? desbloqueamos ele.
		unlockedMatter[thisMatter] = true
		emit_signal("matterUnlocked", thisMatter)
			
	primeMatter[thisMatter] += amount              #finalmente, incrementamos o item
	emit_signal("matterChanged", thisMatter, primeMatter[thisMatter])

func spendMatter(thisMatter, amount):
	if primeMatter.has(thisMatter):
		if primeMatter[thisMatter] >= amount:
			primeMatter[thisMatter] -= amount
			emit_signal("matterChanged", thisMatter, primeMatter[thisMatter])

func hasEnoughMatter(thisMatter, amount) -> bool:
	return primeMatter.get(thisMatter, 0) >= amount
 
func getMatterAmount(thisMatter):
	return primeMatter.get(thisMatter, 0)
