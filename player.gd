extends CharacterBody2D

const SPEED = 500.0
const AIR_CONTROL = 0.6
const GRAVITY = 2000.0

const SHOOT_FORCE = 1050.0
const RELOAD_TIME = 1

var can_shoot = true
var reload_progress = 1
var reload_timer = 0.0

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	var direction := Input.get_axis("Left", "Right")
	
	if direction != 0:
		var control = 1.0 if is_on_floor() else AIR_CONTROL
		velocity.x = lerp(
			velocity.x,
			direction * SPEED,
			0.25 * control
		)
	else:
		if is_on_floor():
			velocity.x = move_toward(
				velocity.x,
				0,
				3000 * delta
			)
	if not can_shoot:
		reload_timer += delta
		reload_progress = min(
			reload_timer / RELOAD_TIME,
			1.0
		)
	else:
		reload_progress = 1.0	
	
	if Input.is_action_just_pressed("Shoot1") and can_shoot:
		shoot()
		
	move_and_slide()
	
	queue_redraw()

func shoot():
	var direction = (
		get_global_mouse_position()
		- global_position
	).normalized()
	
	velocity -= direction * SHOOT_FORCE
	can_shoot = false
	reload_timer= 0.0
	reload_progress = 0.0
	
	await get_tree().create_timer(RELOAD_TIME).timeout
	can_shoot = true
	
func _draw():
	var width := 40.0
	var height := 5.0
	var x := -width / 2
	var y := -40.0
	
	draw_rect(
		Rect2(x, y, width, height),
		Color.DARK_GRAY
	)
	
	draw_rect(
		Rect2(
			x, y, width * reload_progress, height),
			Color.WHITE
	)
