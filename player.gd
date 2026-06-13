extends CharacterBody2D

const SPEED = 400.0
const SHOOT_FORCE = -800.0

var can_shoot: bool = true
var is_recoiling: bool = false

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction := Input.get_axis("Left", "Right")
	if not is_recoiling:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 20)
	if Input.is_action_just_pressed("Shoot1") and can_shoot:
		shoot()
	move_and_slide()

func shoot():
	var shoot_direction = global_position.direction_to(get_global_mouse_position())
	velocity = shoot_direction * SHOOT_FORCE
	can_shoot = false
	is_recoiling = true
	await get_tree().create_timer(0.5).timeout
	is_recoiling = false
	await get_tree().create_timer(0.85).timeout
	can_shoot = true
	
