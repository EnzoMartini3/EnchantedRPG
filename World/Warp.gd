extends Area2D
class_name Warp

export var targetScene: String
export var targetWarp: String
export var spawnDirection = "right"

onready var spawn = $Spawnpoint #position2d

func _on_Warp_body_entered(body):
	if body is Player:
		set_deferred("monitoring", false) 
		var worldNode = get_tree().get_root().get_node("World")
		worldNode.goToScene(targetScene, targetWarp)
