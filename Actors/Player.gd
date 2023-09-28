extends KinematicBody2D

var velocity = Vector2.ZERO
export var speed = Vector2(2000, 2000)
export var gravity = 5000
export var jump_amount = 5000

func _ready() -> void:
	pass

var ui_mask = Vector2(1, 0)
var gravity_mask = Vector2(0, 1)
var last_rotate_t = Time.get_ticks_msec()
const ROTATE_COOLDOWN = 100

func _physics_process(delta: float) -> void:
	var ui_direction = Vector2.ZERO
	ui_direction.x = (Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left"))
	ui_direction.y = (Input.get_action_strength("ui_down")
		- Input.get_action_strength("ui_up"))
		
	if (Time.get_ticks_msec() - last_rotate_t) > ROTATE_COOLDOWN:
		if Input.is_action_just_pressed("jump"):
			last_rotate_t = Time.get_ticks_msec()
			
			# check we are on the wall
			# gravity_mask.rotated(PI/2)
			
				
			if is_on_wall() and not is_on_floor():
				gravity_mask = gravity_mask.rotated(-PI/2)
				rotate(-PI/2)
				
			if is_on_ceiling():
				gravity_mask = gravity_mask.rotated(PI)
				rotate(PI)
		
	if abs(gravity_mask.x) > abs(gravity_mask.y):
		ui_mask = Vector2(0, 1) 
	else:
		ui_mask = Vector2(1, 0)
	
	# calculate ui movement
	velocity = ((speed * ui_direction * ui_mask) +
		velocity * (Vector2.ONE - ui_mask))
		
	# calculate gravity
	velocity += gravity * gravity_mask * delta
	
	# calculate jump is anti-gravity action
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity += -gravity_mask * jump_amount
		
	# interrupted jump
	if Input.is_action_just_released("jump"):
		if abs(gravity_mask.x) > 0:
			velocity.x = 0
		if abs(gravity_mask.y) > 0:
			velocity.y = 0
	
	velocity = move_and_slide(velocity, -gravity_mask)
