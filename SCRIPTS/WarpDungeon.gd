extends Area2D
class_name WarpDungeon

export(String) var returnName
export(PackedScene) var targetScene
export(String) var targetSpawnpoint
export var spawnDirection = "right"
signal dungeonEntered(packedScene, spawnPointName, returnName)

func _on_WarpDungeon_body_entered(body):
	if body is Player:
		emit_signal("dungeonEntered", targetScene, targetSpawnpoint, returnName)
