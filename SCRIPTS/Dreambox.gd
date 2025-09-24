extends Area2D

export(String, FILE, "*.tscn") var houseScenePath: String = "res://Gimmicks/DreamHouse.tscn"
export var exitSpawnPoint: String = "HouseExitSpawn"


func _on_Dreambox_area_entered(area):
	var worldRoot = get_tree().get_root().find_node("World")
	worldRoot.goToScene(houseScenePath, exitSpawnPoint)
