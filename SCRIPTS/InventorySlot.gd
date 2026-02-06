extends CenterContainer

var inventory = preload("res://Player/Inventory.tres")

onready var itemTexture = $ItemTexture
onready var count = $ItemTexture/CountLabel

func slotDisplayItem(thisItem):
	if thisItem is Item:           #se houver um item no slot, o sprite dele será exibido. Caso contrário, preenchemos com o EMPTY
		itemTexture.texture = thisItem.texture
		count.text = str(thisItem.amount)
	else:
		itemTexture.texture = preload("res://SPRITES/Items/EMPTY.png")
		count.text = ""


func get_drag_data(_position):     #(built-in do nó control)
	var itemIndex = get_index()
	var itemRemoved = inventory.removeItem(itemIndex)
	if itemRemoved is Item:
		var data = {}                #criamos um dicionário
		data.item = itemRemoved      #criamos variáveis para o dicionário
		data.itemIndex = itemIndex
			
		var dragPreview = TextureRect.new()     #criamos um novo TextureRect pra mostrar o item sendo arrastado
		dragPreview.texture = itemRemoved.texture
		set_drag_preview(dragPreview)
		inventory.dragData = data
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	var myItemIndex = get_index()
	var myItem = inventory.items[myItemIndex]
	if myItem is Item and myItem.name == data.item.name:
		myItem.amount += data.item.amount
		inventory.emit_signal("itemsChanged", [myItemIndex])
	else:
		inventory.swapItems(myItemIndex, data.itemIndex)     #colocamos o item a ser mexido em um lugar
		inventory.setItem(myItemIndex, data.item)            #concluímos a troca colocando o item que perdeu seu lugar no lugar do item que tomou seu lugar
	inventory.dragData = null
