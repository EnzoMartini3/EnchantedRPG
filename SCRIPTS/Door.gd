extends Area2D

onready var animatedSprite = $AnimatedSprite
export var destinyWarp: String

func _on_Door_body_entered(body):
	if body is Player:
		#show "enter" popup ("press E!")
		if Input.is_action_just_pressed("interact"):
			print("b")
			animatedSprite.play("open")
			#play fadeout animation
			goToHouse(body)

func goToHouse(_player):
	print("goToHouse")
