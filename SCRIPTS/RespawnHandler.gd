extends Node

onready var timer = $ReadyTimer
export var phasesToRespawn = 1
var phasesNeeded = phasesToRespawn
var readyToRespawn = false


func thisItemObtained():
	phasesNeeded = phasesToRespawn       # ao ser coletado, o máximo de fases deve passar antes que o item respawne
	timer.start()                        # então iniciamos um timer pra que o item não seja coletado logo antes da fase resetar

func _on_ReadyForRespawnTimer_timeout():
	readyToRespawn = true    # item pronto pra respawn


func _phaseChanged():
	if readyToRespawn:                   # quando uma fase passa, ela conta APENAS SE O ITEM ESTIVER PRONTO PRA RESPAWN.
		phasesNeeded -= 1
		if phasesNeeded == 0:            # fases máximas já passaram, item respawna
			self.get_parent().respawn()  # TEMP TEMP TEMP TEMP TEMP
			readyToRespawn = false       # ao respawnar ele volta ao início
