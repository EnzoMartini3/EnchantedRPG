extends KinematicBody2D

const Acceleration = 500 # antigo: 15
const Max_Speed = 135 # antigo: 135
const Friction = 575 # antigo: 100

var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * Max_Speed, Acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
# "Whenever you have something that changed over time (if its connected to your framerate), 
# you have to multiply that by delta."

	velocity = move_and_slide(velocity)
