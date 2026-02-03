extends KinematicBody2D
class_name NPCShop

export(String) var dialogueID = ""
export(String) var shopID = ""
export(Texture) var portrait
onready var sprite = $Sprite
onready var hud = get_tree().get_root().find_node("HUD", true, false)


func _interact(): # INÚTIL ATUALMENTE. USAMOS A INTERAÇÃO A PARTIR DO PLAYER E AS FUNÇÕES ABAIXO. ESSA FUNÇÃO ESTÁ AQUI PRA FUTURAS IMPLEMENTAÇÕES.
	var playerNode = get_tree().get_root().find_node("Player", true, false)
	hud.startDialogueUI(self.dialogueID, playerNode, self) # chama a HUD enviando o código do dialogo a ser tocado


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

func dialogicSignalReceived(parameter):
	if parameter == "openShop":
		selfOpenShop()

func selfOpenShop():
	hud.hudOpenShop(shopID, portrait)

func selfCloseShop():
	hud.hudCloseShop()
