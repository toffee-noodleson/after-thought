extends Camera2D

@onready var shake_timer: Timer = $ShakeTimer

var _shake: bool = false
var _shake_min: float = -3
var _shake_max: float = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_core_hit.connect(on_core_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _shake:
		camera_shake()

func on_core_hit() -> void:
	shake_timer.start()
	_shake = true

func camera_shake() -> void:
	position = Vector2(randf_range(_shake_min, _shake_max), randf_range(_shake_min, _shake_max))


func _on_shake_timer_timeout() -> void:
	_shake = false
	position = Vector2.ZERO
