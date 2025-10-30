class_name Player
extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox
onready var hitFlash = $HitFlash
onready var interactionZone = $InteractionRange
onready var crystalArmor = $CrystalArmor
onready var swordHitbox = $SwordHitboxPivot/SwordHitbox
onready var armorHitbox = $ArmorHitboxPivot/ArmorHitbox
onready var armorHitboxBug = $ArmorHitboxPivot/ArmorHitbox/CollisionShape2D #BUG VISUAL
onready var armorAnimations = $CrystalArmor/IdleAnimation

export var acceleration = 400
export var maxSpeed = 100
export var friction = 750
export var maxJumpStamina = 90
export var staminaRecoveryRate = 15
export var inventory: Resource
var jumpStamina = maxJumpStamina
var enemyTrapping = null

signal armorFuelChanged(value)
export var maxArmorFuel = 120
export var fuelUsage = 15
export var armorRegen = 10
var crystalArmorInstance = null
var armorFuel = maxArmorFuel setget setArmorFuel
var armorActive = false

var state = MOVE
var velocity = Vector2.ZERO
var rollVector = Vector2.RIGHT
var stats = PlayerStats

enum {
	MOVE,
	ROLL,
	ATTACK,
	POWERPUNCH,
	IMMOBILE
	BINDED
}

func _ready():
	stats.connect("noHealth", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockbackVector = rollVector #knockback padrão, por isso nao precisamos multiplicar por knockbackPower
	armorHitbox.knockbackVector = rollVector * armorHitbox.knockbackPower
	armorHitboxBug.disabled = true


func _physics_process(delta):
	if jumpStamina < maxJumpStamina: # LÓGICA DE STAMINA DE SALTO
		jumpStamina += staminaRecoveryRate * delta
		if jumpStamina > maxJumpStamina:
			jumpStamina = maxJumpStamina
	
	match state: #switch case
		MOVE: #se state = MOVE, execute movestate, etc.
			moveState(delta)
			
		ROLL:
			rollState(delta)
			
		ATTACK:
			attackState(delta)
			
		POWERPUNCH:
			armoredAttackState(delta)
			
		IMMOBILE:
			immobileState(delta)
			
		BINDED:
			trappedState(delta)
	
	if Input.is_action_just_pressed("interact"):
		if state == MOVE and velocity == Vector2.ZERO: #AVALIAR ESSA DE VELO ZERO, TALVEZ SIM PRA NPCS E NAO PRA ITENS
			lookForNPCS()
	
	if Input.is_action_just_pressed("crystalArmor") and not armorActive:
		activateArmor()
	elif Input.is_action_just_pressed("crystalArmor"):
		deactivateArmor()
	if armorActive: 
		self.armorFuel -= delta * fuelUsage
		if armorFuel <= 0:
			deactivateArmor()
	elif armorFuel < maxArmorFuel:
			self.armorFuel += armorRegen * delta
			if armorFuel > maxArmorFuel + fuelUsage: 
				self.armorFuel = maxArmorFuel + fuelUsage


func moveState(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	rollVector = input_vector
	
	if input_vector != Vector2.ZERO:
		swordHitbox.knockbackVector = input_vector * 1.05
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/PowerPunch/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * maxSpeed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animationState.travel("Idle")
# "Whenever you have something that changed over time (if its connected to your framerate), you have to multiply that by delta."
	move()
	if Input.is_action_just_pressed("attack"):
		if armorActive:
			state = POWERPUNCH
		else:
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


func lookForNPCS():
	var closest = null
	var minDistance = 5000
	var targetsInArea = interactionZone.get_overlapping_bodies()
	for area in targetsInArea:
		var npcNode = area
		var distance = global_position.distance_to(npcNode.global_position)
		if distance < minDistance:
				minDistance = distance
				closest = npcNode
	if closest is NPC:
		var hudNode = get_tree().get_root().find_node("HUD", true, false)
		state = IMMOBILE
		animationState.travel("Idle")
		hudNode.startDialogueUI(closest.dialogueString, self, closest) # chama a HUD enviando o código do dialogo a ser tocado


func _on_Hurtbox_area_entered(area):
	if "damage" in area:
		stats.health -= area.damage
		hurtbox.makeImmortal(0.5)
		hurtbox.createHitEffect()


func _on_Hurtbox_immortalStart():
	hitFlash.play("Start")


func _on_Hurtbox_immortalEnd():
	hitFlash.play("Stop")


func connectToHUD():
	var hudNode = get_tree().get_root().find_node("HUD", true, false)
	connect("armorFuelChanged", hudNode, "updateFuel")
	hudNode.updateFuel(armorFuel)


func setArmorFuel(value):
	armorFuel = value
	emit_signal("armorFuelChanged", armorFuel)


func activateArmor():
	armorActive = true
	if armorFuel >= 0:
		self.armorFuel -= fuelUsage # gasto inicial, buffer
	else: 
		self.armorFuel = 0
	crystalArmor.armorAmplification(self)


func deactivateArmor():
	armorActive = false
	crystalArmor.removeAmplification(self)


func armoredAttackState(_delta):
	velocity = Vector2.ZERO
	animationState.travel("PowerPunch")
	#armorAnimations.play("Punch")


func immobileState(_delta):
	velocity = Vector2.ZERO

func trappedState(_delta):
	velocity = Vector2.ZERO
	# animationState.travel("Preso")
	if Input.is_action_just_pressed("interact"):
		if enemyTrapping:
			enemyTrapping.onPlayerInteraction()

func setTrappedState(isTrapped: bool, trappingEntity = null):
	if isTrapped:
		state = BINDED
		velocity = Vector2.ZERO
		#animationState.travel("Preso") # Ou uma animação de "idle" presa
		enemyTrapping = trappingEntity # Guarda a referência do inimigo que prendeu
	else:
		state = MOVE
		#animationState.travel("Idle")
		enemyTrapping = null
