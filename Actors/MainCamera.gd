extends Camera2D
export(float, EASE) var DAMP_EASING = 1
export var duration = 0.2
export var amplitude = 40
var shake = false

var noise = OpenSimplexNoise.new()

onready var shake_timer = $ShakeTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	noise.period = 0.02
	set_process(false)
	set_shake(false)

func _process(delta: float) -> void:
	var t = shake_timer.time_left / shake_timer.wait_time
	var damping = ease(t, DAMP_EASING) * amplitude
	
	offset = Vector2(
		noise.get_noise_2d(1, t) * damping,
		noise.get_noise_2d(10, t) * damping
	)

func _on_ShakeTimer_timeout() -> void:
	set_shake(false)

func _on_Player_stomped() -> void:
	set_shake(true)
	
func set_shake(value):
	shake = value
	offset = Vector2.ZERO
	if shake:
		noise.seed = randi()
		shake_timer.set_wait_time(duration)
		shake_timer.start()
		set_process(true)
	else:
		set_process(false)

