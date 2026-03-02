extends KinematicBody2D
class_name NPC

onready var sprite = $Sprite

export var dialogueID = ""
export var residentTown= "Tinymint"

enum { IDLE, BUSY }
var talkChance = 40
var currentRep = "Neutral"
var state = IDLE

func _physics_process(_delta):
	match state:
		IDLE:
			pass #lógica de andar
		BUSY:
			pass

func lookAtPlayer(player: KinematicBody2D):
	var direction = (player.global_position - global_position).normalized()
	if abs(direction.x) > abs(direction.y):     #Horizontal
			if direction.x < 0:
				sprite.frame = 0 #ESQUERDA
			else:
				sprite.frame = 1 #DIREITA
	else:                                       #Vertical
			if direction.y < 0:
				sprite.frame = 3 #CIMA
			else:
				sprite.frame = 2 #BAIXO

func dialogueStarted():
	state = BUSY

func dialogueEnded():
	state = IDLE

func _onReputationChanged(_thisTown, _newReputation):
	pass
	#NPCS.currentRep = newReputation
