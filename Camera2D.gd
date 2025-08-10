extends Camera2D

onready var topLeft = $MapLimits/TopLeft
onready var bottomRight = $MapLimits/BottomRight

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
