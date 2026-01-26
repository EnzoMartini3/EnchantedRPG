extends Area2D
class_name Warp

export(PackedScene) var targetScene
export(String) var targetSpawnpoint
export var spawnDirection = "right"
signal warpEntered(packedScene, spawnPointName)

func _on_Warp_body_entered(body):
	if body is Player:
		emit_signal("warpEntered", targetScene, targetSpawnpoint)
