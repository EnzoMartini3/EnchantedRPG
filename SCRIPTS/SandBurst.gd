extends Area2D

onready var warningAnimatedSprite = $WarningSprite
onready var geyserSprite = $GeyserSprite
onready var animationPlayer = $AnimationPlayer

func _ready():
	$Hitbox/CollisionShape2D.disabled = true
	geyserSprite.visible = false
	warningAnimatedSprite.visible = true
	warningAnimatedSprite.play("Animate")

func _on_WarningSprite_animation_finished():
	warningAnimatedSprite.visible = false
	geyserSprite.visible = true
	animationPlayer.play("Eruption")

func _on_AnimationPlayer_animation_finished(_Eruption):
	queue_free()
