class_name Player

extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox
onready var hitFlash = $HitFlash
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var collisionShape = $HitboxPivot/SwordHitbox/CollisionShape2D

export var acceleration = 400
export var maxSpeed = 100
export var friction = 750
export var maxJumpStamina = 90
export var staminaRecoveryRate = 15
var jumpStamina = maxJumpStamina

const crystalArmorScene = preload("res://Powers & Gems/Crystal Armor.tscn")
signal armorFuelChanged(value)
export var maxArmorFuel = 120
export var fuelUsage = 15
export var armorRegen = 10
var crystalArmorInstance = null
var armorFuel = maxArmorFuel setget setArmorFuel
var armorActive = false
var enemyTrapping = null

enum {
	MOVE,
	ROLL,
	ATTACK,
	TRAPPED
}

var state = MOVE
var velocity = Vector2.ZERO
var rollVector = Vector2.RIGHT
var stats = PlayerStats

func _ready():
	randomize()
	#collisionShape.disabled = true
	stats.connect("noHealth", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = rollVector
	var hudNode = get_tree().get_root().find_node("HUD", true, false)
	connect("armorFuelChanged", hudNode, "updateFuel")
	hudNode.updateFuel(armorFuel)

func _physics_process(delta):
	if jumpStamina < maxJumpStamina: # LÓGICA DE STAMINA DE SALTO
		jumpStamina += staminaRecoveryRate * delta
		if jumpStamina > maxJumpStamina:
			jumpStamina = maxJumpStamina
	
	if Input.is_action_just_pressed("crystalArmor") and not armorActive:
		activateArmor()
	elif Input.is_action_just_pressed("crystalArmor"):
		deactivateArmor()
	#print(armorFuel) #LÓGICA DE ARMADURA
	if armorActive: 
		self.armorFuel -= delta * fuelUsage
		if armorFuel <= 0:
			deactivateArmor()
	elif armorFuel < maxArmorFuel:
			self.armorFuel += armorRegen * delta
			if armorFuel > maxArmorFuel + fuelUsage: 
				self.armorFuel = maxArmorFuel + fuelUsage
		
	match state: #switch case
		MOVE: #se state = MOVE, execute movestate, etc.
			moveState(delta)
			
		ROLL:
			rollState(delta)
			
		ATTACK:
			attackState(delta)
			
		TRAPPED:
			trappedState(delta)

func moveState(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	rollVector = input_vector
	
	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector * 1.05
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * maxSpeed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animationState.travel("Idle")
# "Whenever you have something that changed over time (if its connected to your framerate), 
# you have to multiply that by delta."
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("roll") and jumpStamina >= 40:
		state = ROLL
		jumpStamina -= 40

func rollState(_delta):
	velocity = rollVector * maxSpeed * 1.1
	animationState.travel("Roll")
	move()

func attackState(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	state = MOVE
	velocity *= 0.75

func attack_animation_finished():
	state = MOVE

func _on_Hurtbox_area_entered(area):
	if area.get_parent() is Enemy:
		stats.health -= area.damage
		hurtbox.makeImmortal(0.5)
		hurtbox.createHitEffect()

func _on_Hurtbox_immortalStart():
	hitFlash.play("Start")

func _on_Hurtbox_immortalEnd():
	hitFlash.play("Stop")

func setArmorFuel(value):
	armorFuel = value
	emit_signal("armorFuelChanged", armorFuel)

func activateArmor():
	armorActive = true
	if armorFuel >= 0:
		self.armorFuel -= fuelUsage # gasto inicial, buffer
	else: 
		self.armorFuel = 0
	crystalArmorInstance = crystalArmorScene.instance()
	add_child(crystalArmorInstance)
	crystalArmorInstance.armorAmplification(self)

func deactivateArmor():
	armorActive = false
	crystalArmorInstance.removeAmplification(self)
	crystalArmorInstance.queue_free()
	crystalArmorInstance = null

func trappedState(_delta):
	velocity = Vector2.ZERO
	# animationState.travel("Preso")
	if Input.is_action_just_pressed("interact"):
		if enemyTrapping:
			enemyTrapping.onPlayerInteraction()

func setTrappedState(isTrapped: bool, trappingEntity = null):
	if isTrapped:
		state = TRAPPED
		velocity = Vector2.ZERO
		#animationState.travel("Preso") # Ou uma animação de "idle" presa
		enemyTrapping = trappingEntity # Guarda a referência do inimigo que prendeu
	else:
		state = MOVE
		#animationState.travel("Idle")
		enemyTrapping = null
