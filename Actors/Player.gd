extends KinematicBody2D

var velocity = Vector2.ZERO
export var speed = Vector2(20000, 20000)
export var gravity = 5000

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var ui_direction = Vector2.ZERO
	ui_direction.x = (Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left"))
	ui_direction.y = (Input.get_action_strength("ui_down")
		- Input.get_action_strength("ui_up"))
		
	var ui_mask = Vector2(1, 0)
	var gravity_mask = Vector2(0, 1)
	
	velocity = (speed * ui_direction * ui_mask +
		gravity * gravity_mask) * delta
	
	velocity = move_and_slide(velocity)
