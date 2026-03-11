extends Resource
class_name LifelightLily

signal petalsChanged(current, maxPetals)
signal lilyLevelUp(newLevel, newMaxPetals)

export(Texture) var sprite

export var level: int = 0
export var maxPetals: int = 0
export var petals: int = 0

func unlockLily():
	levelUp()

func usePetal():
	if petals > 0:
		petals -= 1
		emit_signal("petalsChanged", petals, maxPetals)
	else:
		ErrorHandler.launchError("Nenhuma Pétala restante.")

func restorePetals():
	petals = maxPetals
	emit_signal("petalsChanged", petals, maxPetals)

func restorePetalAmount(amount):
	petals += amount
	emit_signal("petalsChanged", petals, maxPetals)

func levelUp():
	level += 1
	maxPetals = 2 + level       #CONSIDERANDO QUE CADA UPGRADE = +1 PÉTALA E NÍVEL 1 COMEÇA COM 3 PÉTALAS
	petals = maxPetals
	#SPRITE.UPDATE
	emit_signal("lilyLevelUp", level, maxPetals)
	emit_signal("petalsChanged", petals, maxPetals)
