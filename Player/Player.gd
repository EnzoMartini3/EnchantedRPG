extends KinematicBody2D

export var acceleration = 400 # antigo: 15
export var maxSpeed = 100 # antigo: 135
export var friction = 750 # antigo: 100
export var staminaRecoveryRate = 10
export var maxStamina = 90
var stamina = maxStamina

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.RIGHT

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	if stamina < maxStamina:
		stamina += staminaRecoveryRate * delta
		if stamina > maxStamina:
			stamina = maxStamina

	match state: #basicamente um switch case, funcionaria também com if-else
		MOVE: #se o state matches MOVE, execute movestate, etc.
			moveState(delta)

		ROLL:
			rollState(delta)

		ATTACK:
			attackState(delta)

func moveState(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	roll_vector = input_vector
	
	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector
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
	
	if Input.is_action_just_pressed("roll") and stamina >= 40:
		state = ROLL
		stamina -= 40

func rollState(delta):
	velocity = roll_vector * maxSpeed * 1.1
	animationState.travel("Roll")
	move()

func attackState(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	state = MOVE
	velocity *= 0.75

func attack_animation_finished():
	state = MOVE
