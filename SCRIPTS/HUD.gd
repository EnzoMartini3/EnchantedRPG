extends CanvasLayer

onready var crystalBar = $CrystalBar
onready var inventory = $InventoryHUD
onready var shopUI = $ShopUI
onready var shopPortrait = $ShopUI/ShopKeeperPortrait   # seria um animated sprite, mantemos TextureRect ou mudamos?
onready var audioOpen = $InventoryHUD/AudioOpen
onready var audioClose = $InventoryHUD/AudioClose

var inventoryOpen = false
var currentPlayer = null
var currentNpc = null

func _ready():
	closeInventory()

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
			if inventoryOpen:
				closeInventory()
			else:
				openInventory()

func updateFuel(value: float):
	crystalBar.value = value

func startDialogueUI(dialogueID: String, talkingPlayer: Node, talkingNpc: Node):
	currentPlayer = talkingPlayer
	currentNpc = talkingNpc
	currentPlayer.state = currentPlayer.IMMOBILE     # player congela, em seguida vai fazer o mesmo com o npc mas com palavras diferentes
	if currentNpc.has_method("dialogueStarted"):
		currentNpc.dialogueStarted()                     # o npc usa uma lógica diferente pro caso de querer adicionar uma reaçãozinha na função dele quando o dialogo acaba
	crystalBar.visible = false
			
	var newDialogue = Dialogic.start(dialogueID)
	add_child(newDialogue) #trigga o dialogo
	newDialogue.connect("timeline_end", self, "endDialogueUI")
	if talkingNpc.has_method("dialogicSignalReceived"):     # Player está falando com um lojista?        
		newDialogue.connect("dialogic_signal", talkingNpc, "dialogicSignalReceived")

func endDialogueUI(_timelineName):
	currentPlayer.state = currentPlayer.MOVE
	if currentNpc.has_method("dialogueEnded"):
		currentNpc.dialogueEnded()
	currentPlayer = null
	currentNpc = null
	crystalBar.visible = true


func openInventory():
	get_tree().paused = true
	audioOpen.play()
	inventory.visible = true
	inventoryOpen = true

func closeInventory():
	get_tree().paused = false
	audioClose.play()
	inventory.visible = false
	inventoryOpen = false

func hudOpenShop(shopID, npcPortrait):
	shopPortrait.texture = npcPortrait
	shopUI.visible = true                  # NÃO TESTADO E REQUER MELHOR IMPLEMENTAÇÃO
	get_tree().paused = true

func hudCloseShop():
	shopUI.visible = false                 # NÃO TESTADO
	get_tree().paused = false
