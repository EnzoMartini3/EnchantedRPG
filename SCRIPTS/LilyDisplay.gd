extends Control
class_name LilyDisplay

onready var sprite = $LevelSprite
onready var petalLabel = $LevelSprite/PetalAmount
var inventory = preload("res://Player/Inventory.tres")

func _ready():
	inventory.lifelightLily.connect("petalsChanged", self, "_onPetalsChanged")
	updateSprite(inventory.lifelightLily.petals)

func _onPetalsChanged(petals):
	updateSprite(petals)

func updateSprite(petals):
	sprite.frame = inventory.lifelightLily.maxPetals - petals   #começa do max
