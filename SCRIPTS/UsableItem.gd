extends Item
class_name Usable

export(PackedScene) var effectScene

func triggerEffect(thisPosition, parent):
	var effect = effectScene.instance()
	parent.add_child(effect)
	effect.global_position = thisPosition
	parent.amount -= 1
