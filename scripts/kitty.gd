extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = 250.0
var gravity_down = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if gravity_down:
			velocity += get_gravity() * delta
		else:
			velocity -= get_gravity() * delta
	
	if is_on_floor():
		$AnimatedSprite2D.play("running")
	else:
		$AnimatedSprite2D.play("idle_side")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		if gravity_down:
			velocity.y = -JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("gravity") and is_on_floor():
		gravity_down = !gravity_down
		
	move_and_slide()
