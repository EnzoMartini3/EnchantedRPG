class_name HeartEntity
extends Area2D

onready var respawnTimer = $RespawnTimer
export var healing = 1

const HealerDeathEffect = preload("res://Effects/HeartyHealEffect.tscn")

func _on_HeartEntity_area_entered(area):
	if area.get_parent() is Player:
		if PlayerStats.health != PlayerStats.maxHealth:  #IMPEDE QUE A COLETA CASO FULL VIDA
			PlayerStats.healEntity(healing) #cura
			
			queue_free() #efeitos de morte
			var heartDeathEffect = HealerDeathEffect.instance()
			get_parent().add_child(heartDeathEffect)
			heartDeathEffect.global_position = global_position
