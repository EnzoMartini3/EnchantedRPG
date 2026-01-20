extends Node

signal dayPassed()
signal phaseChanged(newPhase)
onready var timer = $DayPhaseTimer

enum DayPhase {
	MORNING,
	AFTERNOON,
	NIGHT
}
var dayCount = 1
var currentPhase = DayPhase.MORNING
var phaseDuration = {
	DayPhase.MORNING: 150.0,
	DayPhase.AFTERNOON: 350.0,
	DayPhase.NIGHT: 200.0
}

func _ready():
	startPhase(DayPhase.MORNING)

func _on_DayPhaseTimer_timeout():
	nextPhase()                                # transiciona pra próx. fase quando o tempo da fase atual acaba 

func nextPhase():
	match currentPhase:                        # usamos funções startPhase pra não ter que setupar o código intiero em cada variação do match 
		DayPhase.MORNING:
			#animação de transição
			startPhase(DayPhase.AFTERNOON)
		DayPhase.DAY:
			startPhase(DayPhase.NIGHT)
		DayPhase.NIGHT:
			dayCount += 1
			emit_signal("dayPassed")
			startPhase(DayPhase.MORNING)


func startPhase(desiredPhase):
	currentPhase = desiredPhase
	var duration = phaseDuration[desiredPhase]
	timer.start(duration)
	emit_signal("phaseChanged", currentPhase)               # EMITE SINAL PRO WORLD
	get_tree().call_group("Respawnables", "_phaseChanged")  # EMITE SINAL PROS RESPAWNÁVEIS


func timeSkip(timeToSkip):
	if timeToSkip > timer.time_left:
		timeToSkip = timeToSkip - timer.time_left
		nextPhase()
		timeSkip(timeToSkip)
	else:
		timer.start(timer.time_left - timeToSkip)      # "time_left" não é uma varíavel, é apenas pra leitura, por isso precisamos fazer timer.start() de novo
