extends KinematicBody2D
class_name NPC

export var dialogueString = ""
enum { IDLE, BUSY }
var state = IDLE

func _physics_process(_delta):
	match state:
		IDLE:
			pass #lógica de andar
		BUSY:
			pass

func dialogueStarted():
	state = BUSY

func dialogueEnded():
	state = IDLE
