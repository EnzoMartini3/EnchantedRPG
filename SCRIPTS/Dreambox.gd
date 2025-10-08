extends Area2D

func _on_Dreambox_area_entered(_area):
	var worldRoot = get_tree().get_root().find_node("World", true, false)
	set_deferred("monitoring", false)
	worldRoot.dreamboxTrigger(self, "Dream Tent", "TentEntrance")
