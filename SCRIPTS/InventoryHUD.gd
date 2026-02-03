extends ColorRect

var inventory = preload("res://Player/Inventory.tres")

func can_drop_data(_position, data):               #caso o jogador jogue um item pra fora do inventário, o container percebe
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	inventory.setItem(data.itemIndex, data.item)   #ele pega o item e o insere de volta no inventário
