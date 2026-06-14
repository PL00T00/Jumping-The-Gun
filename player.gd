extends CharacterBody2D

const SPEED = 500.0
const WALK_ACCELERATION = 2500.0
const MAX_WALK_SPEED = 500.0
const GROUND_ACCELERATION = 4000.0
const AIR_ACCELERATION = 1500.0
const FRICTION = 35000.0

const SHOOT_FORCE = 750.0
const RELOAD_TIME = 1

var can_shoot = true

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction := Input.get_axis("Left", "Right")
	
	if direction != 0:
		velocity.x += direction * WALK_ACCELERATION * delta
	
	if abs(velocity.x) < MAX_WALK_SPEED:
		velocity.x = clamp(
			velocity.x,
			-MAX_WALK_SPEED,
			MAX_WALK_SPEED
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
	
