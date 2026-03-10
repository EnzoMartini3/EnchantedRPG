extends Node2D

var inventory = preload("res://Player/Inventory.tres")

func _on_CraftButton_pressed():
	var custo_madeira = 5
	if inventory.hasEnough("wood", custo_madeira):
		
		# 2. Consome o material
		inventory.spendMatter("wood", custo_madeira)
		
		# 3. Dá o produto final (Lógica do seu jogo)
		inventory.addMatter("inky", 1)
	else:
		#screen shake
		#red light show up
		pass
