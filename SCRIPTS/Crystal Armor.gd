extends Node2D

onready var sprites = $IdleAnimation
onready var punchSprite = $PowerPunch
onready var shieldSprite = $HyperShield
onready var transformationAudio = $ActivationAudio

var armorActive = false
var playerSpeed = 0.0  # controlador para o buff de velo

func armorAmplification(player: Node):
	transformationAudio.play()
	playerSpeed = player.maxSpeed
	player.maxSpeed *= 1.5
	sprites.get_parent().remove_child(sprites)
	var playerSpriteVisual = player.find_node("Sprite", true, false)
	playerSpriteVisual.add_child(sprites)
	sprites.position = Vector2.ZERO
	sprites.visible = true

func removeAmplification(player: Node):
	player.maxSpeed = playerSpeed
	sprites.visible = false
