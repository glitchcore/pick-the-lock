extends KinematicBody2D

var velocity = Vector2.ZERO
export var speed = Vector2(2000, 2000)
export var gravity = 5000
export var jump_amount = 2000

func _ready() -> void:
	pass

var ui_mask = Vector2(1, 0)
var gravity_mask = Vector2(0, 1)
var last_rotate_t = Time.get_ticks_msec()
const ROTATE_COOLDOWN = 100

# rotate player on hitting on wall
func rotate_player():
	if ((Time.get_ticks_msec() - last_rotate_t) > ROTATE_COOLDOWN and
		Input.is_action_just_pressed("jump")):
		last_rotate_t = Time.get_ticks_msec()
			
		if get_slide_count() > 0:
			var normal = -get_slide_collision(0).normal
			var rotate_angle = gravity_mask.angle_to(normal)
			gravity_mask = normal
			rotate(rotate_angle)
			
			if abs(gravity_mask.x) > abs(gravity_mask.y):
				ui_mask = Vector2(0, 1) 
			else:
				ui_mask = Vector2(1, 0)

func calculate_ui_movement():
	var ui_direction = Vector2.ZERO
	ui_direction.x = (Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left"))
	ui_direction.y = (Input.get_action_strength("ui_down")
		- Input.get_action_strength("ui_up"))
	
	velocity = ((speed * ui_direction * ui_mask) +
		velocity * (Vector2.ONE - ui_mask))

# calculate jump is anti-gravity action
func calculate_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity += -gravity_mask * jump_amount
		
	# interrupted jump
	if Input.is_action_just_released("jump"):
		if abs(gravity_mask.x) > 0:
			velocity.x = 0
		if abs(gravity_mask.y) > 0:
			velocity.y = 0

func _physics_process(delta: float) -> void:
	rotate_player()
	calculate_ui_movement()
	calculate_jump()
	
	# calculate gravity
	velocity += gravity * gravity_mask * delta
	
	velocity = move_and_slide(
		velocity,
		-gravity_mask, # up dir
		false, # stop_on_slope
		4, # max_slides
		PI/4, # floor_max_angle
		false # infinite_inertia
	)
