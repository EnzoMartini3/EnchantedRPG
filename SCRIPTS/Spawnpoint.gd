extends Position2D
class_name Spawnpoints

export(String) var pointName = "Start"

func _ready():
	add_to_group("Spawnpoints")
