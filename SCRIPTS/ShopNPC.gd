extends KinematicBody2D
class_name Shopkeeper

export var dialogueID = ""
export(Texture) var portrait
onready var sprite = $Sprite
onready var hud = get_tree().root.get_node("World/HUD")


func lookAtPlayer(player: KinematicBody2D):
	var direction = (player.global_position - global_position).normalized()
	if abs(direction.x) > abs(direction.y):
			if direction.x < 0: # horizontal
				sprite.frame = 0 #ESQUERDA
			else:
				sprite.frame = 1 #DIREITA
	else: #vertical
			if direction.y < 0:
				sprite.frame = 3 #CIMA
			else:
				sprite.frame = 2 #BAIXO

func selfOpenShop():
	print("234")
	hud.hudOpenShop(portrait)

func selfCloseShop():
	hud.hudCloseShop()
