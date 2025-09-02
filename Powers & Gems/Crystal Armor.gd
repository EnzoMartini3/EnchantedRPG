extends Node

signal armorFuelChanged(value)
signal armorDeactivated
onready var sprites = $Animation

export var maxArmorFuel = 120
export var fuelUsage = 15
export var armorRegen = 12
var armorFuel = maxArmorFuel setget setArmorFuel
var armorActive = false
var playerSpeed = 0.0  # controlador para o buff de velo
var playerNode = null  # ponteiro pro player

func setArmorFuel(value):
	armorFuel = value
	emit_signal("armorFuelChanged", armorFuel)

func _physics_process(delta):
	#print(armorFuel)
	if armorActive: 
		self.armorFuel -= delta * fuelUsage
		if armorFuel <= 0:
			deactivateArmor()
	else:
		if armorFuel < maxArmorFuel:
			self.armorFuel += armorRegen * delta
			if armorFuel > maxArmorFuel + fuelUsage: 
				self.armorFuel = maxArmorFuel + fuelUsage

func activateArmor(player: Node):
	playerNode = player
	self.armorFuel -= fuelUsage # gasto inicial, buffer
	armorActive = true
	playerSpeed = playerNode.maxSpeed
	playerNode.maxSpeed *= 1.5 #buff de velo
	
	var playerSprite = playerNode.find_node("Sprite", true, false) # Pega o AnimatedSprite/Sprite do jogador
	sprites.get_parent().remove_child(sprites)  # Garante que o visual seja adicionado como filho do jogador
	playerSprite.add_child(sprites)
	sprites.global_position = playerSprite.global_position

func deactivateArmor():
	playerNode.maxSpeed = playerSpeed #reseta velo
	armorActive = false
	emit_signal("armorDeactivated")
	sprites.get_parent().remove_child(sprites)
