extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -450.0
const JUMP_PUSHBACK = 250

const WALL_SLIDE_GRAVITY = 150
var is_wall_sliding = false
var is_wall_jumping = false
var wall_jump_timer = 0.0
var jump_count = 0

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		jump_count = 0

# Tiempo del salto en pared
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	else:
		is_wall_jumping = false

# Salto normal
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

# Doble salto
	if Input.is_action_just_pressed("ui_up") and jump_count < 2:
		jump_count += 1
		velocity.y = JUMP_VELOCITY

# Salto en pared
	if Input.is_action_just_pressed("ui_up") and is_on_wall() and not is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_wall_jumping = true
		wall_jump_timer = 0.3

		if Input.is_action_pressed("ui_right"):
			velocity.x = -JUMP_PUSHBACK
		elif Input.is_action_pressed("ui_left"):
			velocity.x = JUMP_PUSHBACK

# Movimiento horizontal (para que no pise el pushback del salto)
	if not is_wall_jumping:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	wall_slide(delta)
	move_and_slide()

# Deslizamiento del personaje en la pared
func wall_slide(delta):
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
		
	if is_wall_sliding:
		velocity.y += (WALL_SLIDE_GRAVITY * delta)
		velocity.y = min(velocity.y, WALL_SLIDE_GRAVITY)
