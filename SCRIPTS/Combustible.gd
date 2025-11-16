class_name Combustible
extends Area2D

onready var respawnTimer = $RespawnTimer
export var fuelProvided = 50

const HealerDeathEffect = preload("res://Effects/HeartyHealEffect.tscn")

func _on_Combustible_area_entered(area): 
	if area.get_parent() is Player: #area detectada é o Player? Ótimo.
		var playerRef = area.get_parent()
		if playerRef.armorFuel != playerRef.maxArmorFuel:  #IMPEDE A COLETA CASO FULL FUEL
			area.get_parent().fuelUp(fuelProvided)   #efetivação do efeito
			
			queue_free() #efeitos de morte
			var heartDeathEffect = HealerDeathEffect.instance()
			get_parent().add_child(heartDeathEffect)
			heartDeathEffect.global_position = global_position
