extends KinematicBody2D

var velocity = Vector2.ZERO
export var speed = 1000
export var gravity = 5000
export var jump_amount = 2000
export var acceleration = 8000

func _ready() -> void:
	pass

var slide_direction = Vector2(1, 0)
var gravity_direction = Vector2(0, 1)
var last_rotate_t = Time.get_ticks_msec()
const ROTATE_COOLDOWN = 100

signal stomped

# rotate player on hitting on wall
func rotate_player():
	if ((Time.get_ticks_msec() - last_rotate_t) > ROTATE_COOLDOWN and
		Input.is_action_just_pressed("jump")):
		last_rotate_t = Time.get_ticks_msec()
			
		if get_slide_count() > 0:
			var normal = -get_slide_collision(0).normal
			var rotate_angle = gravity_direction.angle_to(normal)
			gravity_direction = normal
			rotate(rotate_angle)
			
			slide_direction = gravity_direction.rotated(-PI/2)

func calculate_ui_movement(delta: float):
	var input = Input.get_axis("ui_left", "ui_right")
	input *= speed
	
	var slide_amount = 0
	if abs(slide_direction.x) > abs(slide_direction.y):
		slide_amount = slide_direction.x * velocity.x
	else:
		slide_amount = slide_direction.y * velocity.y
	
	slide_amount = move_toward(slide_amount, input, delta * acceleration)
	velocity = ((slide_amount * slide_direction) + velocity * gravity_direction.abs())

# calculate jump is anti-gravity action
func calculate_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity += -gravity_direction * jump_amount
		
	# interrupted jump
	if Input.is_action_just_released("jump"):
		if abs(gravity_direction.x) > 0:
			velocity.x = 0
		if abs(gravity_direction.y) > 0:
			velocity.y = 0

func _physics_process(delta: float) -> void:
	rotate_player()
	calculate_ui_movement(delta)
	calculate_jump()
	
	# calculate gravity
	velocity += gravity * gravity_direction * delta
	
	var prev_velocity = velocity
	velocity = move_and_slide(
		velocity,
		-gravity_direction, # up dir
		false, # stop_on_slope
		4, # max_slides
		PI/4, # floor_max_angle
		false # infinite_inertia
	)
	
	var dv = (prev_velocity - velocity).length()
	
	if dv > gravity * delta * 2:
		emit_signal("stomped")
