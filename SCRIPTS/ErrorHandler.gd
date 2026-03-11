extends CanvasLayer

onready var control = $Control
onready var bar = $Control/BarSprite
onready var label = $Control/Text
onready var animationPlayer = $AnimationPlayer

func _ready():
	control.modulate.a = 0

func launchError(errorMessage):
	label.text = errorMessage
	animationPlayer.stop()
	animationPlayer.play("showError")
