extends Area2D
class_name Warp

export var targetScene: String
export var targetWarp: String
export var spawnDirection = "right"

onready var spawn = $Spawnpoint # um position2d

#func _physics_process(delta): #ROTACAO COM PROCESS
#	rotation += 8 * delta

func _on_Warp_body_entered(body):
	if body is Player:
		set_deferred("monitoring", false) 
		var worldNode = get_tree().get_root().get_node("World")
		worldNode.goToScene(targetScene, targetWarp)
