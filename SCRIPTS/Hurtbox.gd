	extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var immortal = false setget setImmortal

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal immortalStart
signal immortalEnd

func setImmortal(value):
	immortal = value
	if(immortal == true):
		emit_signal("immortalStart")
	else:
		emit_signal("immortalEnd")

func makeImmortal(duration):
	self.immortal = true
	timer.start(duration)

func createHitEffect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	self.immortal = false

func _on_Hurtbox_immortalStart():
	collisionShape.set_deferred("disabled", true)

func _on_Hurtbox_immortalEnd():
	collisionShape.disabled = false
