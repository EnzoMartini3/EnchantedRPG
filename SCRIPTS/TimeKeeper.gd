extends Node

signal dayPassed()
signal worldPhaseChanged(newPhase)
onready var timer = $DayPhaseTimer

enum DayPhase {
	MORNING,
	AFTERNOON,
	NIGHT
}
var dayCount = 1
var currentPhase = DayPhase.MORNING
var phaseDuration = {
	DayPhase.MORNING: 150.0,    #150.0
	DayPhase.AFTERNOON: 350.0,  #350.0
	DayPhase.NIGHT: 200.0       #200.0
}

func _ready():
	newPhase(DayPhase.MORNING)

func _on_DayPhaseTimer_timeout():
	startNextPhase()                                # transiciona pra próx. fase quando o tempo da fase atual acaba 

func startNextPhase():
	match currentPhase:                        # usamos funções startPhase pra não ter que setupar o código intiero em cada variação do match 
		DayPhase.MORNING:
			#animação de transição
			newPhase(DayPhase.AFTERNOON)
		DayPhase.AFTERNOON:
			newPhase(DayPhase.NIGHT)
		DayPhase.NIGHT:
			dayCount += 1
			emit_signal("dayPassed")
			newPhase(DayPhase.MORNING)


func newPhase(thisPhase):
	print("Fase do dia atual: ", thisPhase)
	currentPhase = thisPhase
	var duration = phaseDuration[thisPhase]
	timer.start(duration)
	emit_signal("worldPhaseChanged", currentPhase)               # EMITE SINAL PRO WORLD
	get_tree().call_group("Respawnables", "_phaseChanged")  # EMITE SINAL PROS RESPAWNÁVEIS


func timeSkip(thisTime):
	if thisTime > timer.time_left:
		thisTime = thisTime - timer.time_left
		startNextPhase()
		timeSkip(thisTime)
	else:
		timer.start(timer.time_left - thisTime)      # "time_left" não é uma varíavel, é apenas pra leitura, por isso precisamos fazer timer.start() de novo
