extends CanvasLayer

onready var label = $Control/Text
onready var animationPlayer = $AnimationPlayer

func _ready():
	visible = false

func launchError(errorMessage):
	visible = true
	label.text = errorMessage
	animationPlayer.play("showError")
