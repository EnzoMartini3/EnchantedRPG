class_name HeartEntity

extends Area2D

export var healing = 1

const HealerDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

func _on_HeartEntity_area_entered(area):
	if area.get_parent() is Player:
		PlayerStats.healEntity(healing)
		if PlayerStats.health > PlayerStats.maxHealth:
			PlayerStats.health = PlayerStats.maxHealth
		queue_free()
		var heartDeathEffect = HealerDeathEffect.instance()
		get_parent().add_child(heartDeathEffect)
		heartDeathEffect.global_position = global_position
