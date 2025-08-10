class_name Enemy
extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerSeekZone = $PlayerSeekZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var hitFlash = $HitFlash

export var acceleration = 300
export var maxSpeed = 55
export var friction = 300
export var wanderTarget = 4
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

func _ready():
	state = newRandomState([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seekPlayer()
			if wanderController.getTimeLeft() == 0:
				updateWander()
				
		WANDER:
			seekPlayer()
			if wanderController.getTimeLeft()== 0:
				updateWander()
			accelerateTowards(wanderController.targetPosition, delta)
			if global_position.distance_to(wanderController.targetPosition) <= wanderTarget:
				updateWander()
				
		CHASE:
			var player = playerSeekZone.player
			if player != null:
				accelerateTowards(player.global_position, delta)
			else:
				state = IDLE
				
	if softCollision.isColliding():
		velocity += softCollision.getPushVector() * delta * 500
	velocity = move_and_slide(velocity)

func accelerateTowards(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * maxSpeed, acceleration * delta)
	sprite.flip_h = velocity.x < 0

func updateWander():
	state = newRandomState([IDLE, WANDER])
	wanderController.startWanderTimer(rand_range(1, 3))

func seekPlayer():
	if playerSeekZone.canSeePlayer():
		state = CHASE
		
func newRandomState(stateList):
	stateList.shuffle()
	return stateList.pop_front() #pega o primeiro

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 105
	hurtbox.createHitEffect()
	hurtbox.makeImmortal(0.5)

func _on_Stats_noHealth():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
func _on_Hurtbox_immortalStart():
	hitFlash.play("Start")

func _on_Hurtbox_immortalEnd():
	hitFlash.play("Stop")
