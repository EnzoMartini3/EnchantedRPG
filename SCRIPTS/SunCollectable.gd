extends Area2D
class_name SunCollectable

export var sunAmount = 1
onready var animation = $AnimationPlayer
const plimeffect = preload("res://Effects/PlimEffect.tscn")

func _on_Sun_Collectable_area_entered(area):
	if area.get_parent() is Player:
		animation.play("Spin")
		yield (animation, "animation_finished")
		PlayerStats.collectSun(sunAmount)
		queue_free()
		var plim = plimeffect.instance()
		get_parent().add_child(plim)
		plim.global_position = global_position + Vector2(0, -10)
