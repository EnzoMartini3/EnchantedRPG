extends CenterContainer

onready var itemTexture = $ItemTexture

func displayItem(thisItem):
	if thisItem is Item:           # se houver um item no slot, o sprite dele será exibido. Caso contrário, preenchemos com o EMPTY
		itemTexture.texture = thisItem.texture
	else:
		itemTexture.texture = preload("res://SPRITES/Items/EMPTY.png")
