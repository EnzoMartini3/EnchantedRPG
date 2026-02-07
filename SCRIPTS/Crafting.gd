extends Node2D

var inventory = preload("res://Player/Inventory.tres")

func _on_CraftButton_pressed():
	# Exemplo: Refinar 5 Madeiras para criar 1 Carvão
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
