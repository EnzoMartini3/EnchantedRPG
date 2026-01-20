extends CanvasLayer

onready var crystalBar = $CrystalBar
onready var inventory = $InventoryHUD
onready var shopUI = $ShopUI
onready var shopPortrait = $ShopUI/ShopKeeperPortrait   # seria um animated sprite, mantemos TextureRect ou mudamos?

var currentPlayer = null
var currentNpc = null

# aqui tinha um _ready que chamava inventario fechado. tirei pq ficava tocando o som quando o jogo iniciava.

func _input(_event):
	#### FECHAR LOJA
	if shopUI.visible == true:
		if Input.is_action_just_pressed("exit"):
			hudCloseShop()
			get_tree().set_input_as_handled() # termina a função input
	
	#### MOCHILA
	if Input.is_action_just_pressed("inventory"):
		var playerCheck = get_tree().get_root().find_node("Player", true, false)
		if not playerCheck.state == playerCheck.IMMOBILE:  #impede que o inventário seja aberto durante diálogos, cutscenes, etc.
			if inventory.isOpen:
				inventory.closeInventory()
			else:
				inventory.openInventory()

func updateFuel(value: float):
	crystalBar.value = value

func startDialogueUI(dialogueID: String, talkingPlayer: Node, talkingNpc: Node):
	currentPlayer = talkingPlayer
	currentNpc = talkingNpc
	currentPlayer.state = currentPlayer.IMMOBILE # player congela, em seguida vai fazer o mesmo com o npc mas com palavras diferentes
	currentNpc.dialogueStarted() # o npc usa uma lógica diferente pro caso de querer adicionar uma reaçãozinha na função dele quando o dialogo acaba
	crystalBar.visible = false
	
	var newDialogue = Dialogic.start(dialogueID)
	add_child(newDialogue) #trigga o dialogo
	newDialogue.connect("timeline_end", self, "endDialogueUI")
 
func endDialogueUI(_timelineName):
	currentPlayer.state = currentPlayer.MOVE
	currentNpc.dialogueEnded()
	currentPlayer = null
	currentNpc = null
	crystalBar.visible = true


func hudOpenShop(npcPortrait):
	shopPortrait.texture = npcPortrait
	shopUI.visible = true                  # NÃO TESTADO E REQUER MELHOR IMPLEMENTAÇÃO
	get_tree().paused = true

func hudCloseShop():
	shopUI.visible = false                 # NÃO TESTADO
	get_tree().paused = false
