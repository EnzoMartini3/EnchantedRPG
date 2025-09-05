extends Area2D
class_name GroundItem

export var itemPath: Resource

func _on_GroundItem_area_entered(area):
	collectItem(area.get_parent().inventory)

func collectItem(inventory: Inventory):
	inventory.insertItem(itemPath)
	queue_free()

