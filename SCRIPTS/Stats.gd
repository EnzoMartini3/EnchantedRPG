extends Node

export(int) var maxHealth = 1 setget setMaxHealth # HP MAXIMO
var health = maxHealth setget setHealth # HP atual
var sunCollected: int = 0

signal noHealth
signal healthChanged(value)
signal maxHealthChanged

func _ready():
	self.health = maxHealth

func healEntity(value):
	setHealth(health + value)

func collectSun(amount: int):
	sunCollected += amount
	print("Sun collected: ", sunCollected)

func setMaxHealth(value):
	maxHealth = value
	self.health = min(health, maxHealth)
	emit_signal("maxHealthChanged", maxHealth)

func setHealth(value):
	health = value
	emit_signal("healthChanged", health)
	if health <= 0:
		emit_signal("noHealth")
