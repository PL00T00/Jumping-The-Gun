extends CharacterBody2D

const SPEED = 400.0
const SHOOT_UP_FORCE = -300.0

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20)
	if is_on_floor():
		if Input.is_action_just_pressed("Shoot1"):
			velocity.y = SHOOT_UP_FORCE
		
	move_and_slide()
