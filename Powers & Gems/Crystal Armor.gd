extends Node

onready var sprites = $Animation

var armorActive = false
var playerSpeed = 0.0  # controlador para o buff de velo
var playerNode = null  # ponteiro pro player

func armorAmplification(player: Node):
	playerNode = player
	playerSpeed = player.maxSpeed
	player.maxSpeed *= 1.5
	
	var playerSprite = playerNode.find_node("Sprite", true, false)
	sprites.get_parent().remove_child(sprites)
	playerSprite.add_child(sprites)
	sprites.global_position = playerSprite.global_position

func removeAmplification(player: Node):
	player.maxSpeed = playerSpeed
	sprites.get_parent().remove_child(sprites)
