extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = 250.0
var gravity_down: bool = true
@export var lev : bool
@onready var light = %Light
@onready var char = $CollisionShape2D
var gamerunning : bool

func _physics_process(delta: float) -> void:
	var gravity = get_gravity().y
	var up_direction = Vector2.UP if gravity_down else Vector2.DOWN
	set_up_direction(up_direction)
	if not is_on_floor():
			velocity.y += gravity * delta if gravity_down else -gravity * delta
	if gamerunning:
		# Animations
		if is_on_floor():
			$AnimatedSprite2D.play("running")
		else:
			$AnimatedSprite2D.play("idle_side")

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -JUMP_VELOCITY if gravity_down else JUMP_VELOCITY

		if Input.is_action_just_pressed("gravity"):
			gravity_down = !gravity_down
			velocity.y = -JUMP_VELOCITY if gravity_down else JUMP_VELOCITY
			$AnimatedSprite2D.flip_v = not gravity_down
	else:
		if Input.is_action_just_pressed("jump"):
			gamerunning = true
		$AnimatedSprite2D.play("idle_front")

	move_and_slide()
