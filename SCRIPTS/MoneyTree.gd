extends StaticBody2D

onready var dropArea = $DropArea
onready var leavesSprite = $LeavesSprite

export var maxDrops = 5
var dropsLeft
export var fruit: Resource
const fruitScene = preload("res://Item Resources/Collectables/Sun Collectable.tscn")


func _ready():
	dropsLeft = maxDrops


func dayReset():
	dropsLeft = maxDrops
	leavesSprite.frame = 0


func _on_TreeAttackHurtbox_area_entered(_area):
	if dropsLeft > 0:
		spawnFruit()

func spawnFruit():
	var newFruit = fruitScene.instance()
	newFruit.global_position = getNewDropPosition()
	get_parent().call_deferred("add_child", newFruit)
	dropsLeft -= 1
	if dropsLeft == 0:
		leavesSprite.frame = 1  #frutos acabaram: muda o sprite para o sem frutos

func getNewDropPosition():
	var randomX = rand_range(0, dropArea.rect_size.x)
	var randomY = rand_range(0, dropArea.rect_size.y)
	return dropArea.rect_global_position + Vector2(randomX, randomY)


func _on_OpacityZone_body_entered(body):
	if body is Player:
		leavesSprite.modulate.a = 0.35

func _on_OpacityZone_body_exited(body):
	if body is Player:
		leavesSprite.modulate.a = 1.0
