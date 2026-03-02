extends Area2D
class_name GroundItem

export var item: Resource
onready var sprite = $Sprite
var inventory = preload("res://Player/Inventory.tres")

func _ready():
	if item.texture:
		sprite.texture = item.texture

func _on_GroundItem_area_entered(_area):
	collectItem()

func collectItem():
	if inventory.insertItem(item):      #se o inventário não estiver cheio
		queue_free()

