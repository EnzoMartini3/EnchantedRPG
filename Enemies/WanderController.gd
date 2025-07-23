extends Node2D
# WANDERCONTROLLER: UM NÓ QUE CONTROLA A "MOVIMENTACAO AFK" DA CENA. DIMINUA "wanderRange" PARA FAZER A ENTIDADE SE MOVER MAIS OU MENOS
export(int) var wanderRange = 32

onready var startPosition = global_position
onready var targetPosition = global_position
onready var timer = $Timer

func _ready():
	updateTargetPosition()

func updateTargetPosition():
	var targetVector = Vector2(rand_range(-wanderRange, wanderRange), rand_range(-wanderRange, wanderRange))
	targetPosition = startPosition + targetVector

func getTimeLeft():
	return timer.time_left
	
func startWanderTimer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	updateTargetPosition()
