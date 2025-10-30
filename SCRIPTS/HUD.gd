extends CanvasLayer

onready var crystalBar = $CrystalBar
onready var inventory = $InventoryHUD

var currentPlayer = null
var currentNpc = null

# aqui tinha um _ready que chamava inventario fechado. tirei pq ficava tocando o som quando o jogo iniciava.

func _input(_event):
	if Input.is_action_just_pressed("inventory"):
		if inventory.isOpen:
			inventory.closeInventory()
		else:
			inventory.openInventory()

func startDialogueUI(dialogueString: String, talkingPlayer: Node, talkingNpc: Node):
	currentPlayer = talkingPlayer
	currentNpc = talkingNpc
	currentPlayer.state = currentPlayer.IMMOBILE # player congela, em seguida vai fazer o mesmo com o npc mas com palavras diferentes
	currentNpc.dialogueStarted() # o npc usa uma lógica diferente pro caso de querer adicionar uma reaçãozinha na função dele quando o dialogo acaba
	crystalBar.visible = false
	
	var newDialogue = Dialogic.start(dialogueString)
	add_child(newDialogue) #trigga o dialogo
	newDialogue.connect("timeline_end", self, "endDialogueUI")
 
func endDialogueUI(_timelineName):
	currentPlayer.state = currentPlayer.MOVE
	currentNpc.dialogueEnded()
	currentPlayer = null
	currentNpc = null
	crystalBar.visible = true

func updateFuel(value: float):
	crystalBar.value = value
