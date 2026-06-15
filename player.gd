extends CharacterBody2D

const SPEED = 500.0
const GROUND_ACCELERATION = 4000.0
const AIR_ACCELERATION = 1500.0
const FRICTION = 1500.0

const SHOOT_FORCE = 850.0
const RELOAD_TIME = 1

var can_shoot = true

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.3
		
	var direction := Input.get_axis("Left", "Right")
	
	if direction != 0:
		var acceleration = GROUND_ACCELERATION if is_on_floor() else AIR_ACCELERATION
		velocity.x = move_toward(
			velocity.x,
			direction * SPEED,
			acceleration * delta
		)
	elif is_on_floor():
		velocity.x = move_toward(
			velocity.x,
			0,
			FRICTION * delta
		)
		
	if Input.is_action_just_pressed("Shoot1") and can_shoot:
		shoot()
	move_and_slide()

func shoot():
	var shoot_direction = global_position.direction_to(
		get_global_mouse_position()
	)
	
	velocity -= shoot_direction * SHOOT_FORCE
	can_shoot = false
	
	await get_tree().create_timer(RELOAD_TIME).timeout
	can_shoot = true
	
