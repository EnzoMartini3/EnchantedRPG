extends Area2D
class_name WarpDungeon

export var spawnDirection = "up"

func _on_WarpDungeon_body_entered(body):
	if body is Player:
		var worldNode = get_tree().get_root().get_node("World")
		set_deferred("monitoring", false) 
		worldNode.dungeonWarpBack()

