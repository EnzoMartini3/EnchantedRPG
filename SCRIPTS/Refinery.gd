extends Node2D

var inventory = preload("res://Player/Inventory.tres")
var itemOnTable = null

func _onItemPlaced(thisItem):
	itemOnTable = thisItem

func refine():
	var itemCount = itemOnTable.amount
	var type = itemOnTable.refineType
	var totalNum = itemOnTable.yield * itemCount        #multiplica o tanto pelo valor do item (ex: se temos 5 troncos que rendem 3 madeiras: totalNum = 15, que é quanto precisamos adicionar na mochila do player)
	inventory.addMatter(type, totalNum)
