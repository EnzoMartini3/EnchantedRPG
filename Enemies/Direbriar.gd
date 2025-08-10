
extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerSeekZone = $PlayerSeekZone
onready var hitFlash = $HitFlash
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var hitbox = $Hitbox
onready var damageTimer = $DamageTimer 

export var acceleration = 45
export var maxSpeed = 45
export var friction = 380
export var tapsToFree = 5
export var wanderTarget = 4
var initialDamage = 2
var briarDamage = 1
var tapsLeft = tapsToFree
var trappedPlayer = null
const EnemyDeathEffect = preload("res://Effects/DirebriarDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE,
	TRAPPING
}

var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

func _ready():
	state = newRandomState([IDLE, WANDER])
	damageTimer.connect("timeout", self, "_on_DamageTimer_timeout")

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
			
		TRAPPING:
			velocity = Vector2.ZERO
			
				
	if softCollision.isColliding() and state != TRAPPING:
		velocity += softCollision.getPushVector() * delta * 230
	velocity = move_and_slide(velocity)

func accelerateTowards(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * maxSpeed, acceleration * delta)
	sprite.flip_h = velocity.x > 0

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

func _on_Stats_noHealth(): #MORRER
	if state == TRAPPING:
		trappedPlayer.setTrappedState(false)
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
## HITFLASH IMORTALIDADE
func _on_Hurtbox_immortalStart():
	hitFlash.play("Start")
func _on_Hurtbox_immortalEnd():
	hitFlash.play("Stop")

## SNARE
func _on_Hitbox_body_entered(body):
	if body is Player and state != TRAPPING:
		startTrapping(body)

func startTrapping(playerNode: Player):
	state = TRAPPING
	tapsLeft = tapsToFree #reseta contador de taps
	
	trappedPlayer = playerNode
	trappedPlayer.setTrappedState(0)
	
	PlayerStats.health -= initialDamage #dano inicial
	damageTimer.start(2.0)
	playerSeekZone.set_deferred("monitoring", false) # Desativa a detecção de jogador
	playerSeekZone.set_deferred("monitorable", false)

func _on_DamageTimer_timeout():
	if state == TRAPPING:
		PlayerStats.health -= briarDamage
		trappedPlayer.hurtbox.createHitEffect()
	else:
		damageTimer.stop()

func playerTapInteractions():
	if state == TRAPPING:
		tapsLeft -= 1
		if tapsLeft	== 0:
			releasePlayer()

func releasePlayer():
	state = CHASE
	damageTimer.stop()
	
	if trappedPlayer:
		trappedPlayer.setTrappedState(false) # Libera o jogador (pode dar um curto período de invulnerabilidade se setTrappedState for bem feito)
		trappedPlayer = null # Limpa a referência
	
	playerSeekZone.set_deferred("monitoring", true)
	playerSeekZone.set_deferred("monitorable", true)
