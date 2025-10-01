extends Area2D

onready var exitPoint = $ExitPoint
export(String, FILE, "*.tscn") var houseScenePath: String = "res://Buildings/Dream Tent/DreamHouse.tscn"

func _on_Dreambox_area_entered(area):
	print("e")
	var worldRoot = get_tree().get_root().find_node("World")
	worldRoot.goToScene(houseScenePath, exitPoint)
