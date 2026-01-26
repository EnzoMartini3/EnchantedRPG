extends Area2D
class_name WarpReturn

signal returnRequested

func _on_Teleport_Machine_body_entered(body):
	if body is Player:
		emit_signal("returnRequested")
