extends CharacterBody2D

const SPEED = 500.0
const GROUND_ACCELERATION = 4000.0
const AIR_ACCELERATION = 2000.0
const FRICTION = 35000.0

const SHOOT_FORCE = 1100.0
const RELOAD_TIME = 0.35

var can_shoot = true

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction := Input.get_axis("Left", "Right")
	
	if direction != 0:
		var accelerartion = GROUND_ACCELERATION if is_on_floor() else AIR_ACCELERATION
		velocity.x = move_toward(
			velocity.x,
			direction * SPEED,
			accelerartion * delta
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
	
