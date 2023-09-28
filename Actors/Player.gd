extends KinematicBody2D

var velocity = Vector2.ZERO
export var speed = Vector2(20000, 20000)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var ui_speed = Vector2.ZERO
	ui_speed.x = (Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left"))
	ui_speed.y = (Input.get_action_strength("ui_down")
		- Input.get_action_strength("ui_up"))
	
	velocity = speed * ui_speed * delta
	
	velocity = move_and_slide(velocity)
