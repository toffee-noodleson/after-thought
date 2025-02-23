extends Sprite2D

@export var _move_speed: float
@onready var right_wall_detect: RayCast2D = $RightWallDetect
@onready var left_wall_detect: RayCast2D = $LeftWallDetect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StatsDatabase.shared_current_hp = Constants.TOTAL_HP

func _process(delta: float) -> void:
	detect_wall()
	move()

func move() -> void:
	position.x += _move_speed

func detect_wall() -> void:
	if right_wall_detect.is_colliding():
		_move_speed *= -1
		right_wall_detect.enabled = false
		left_wall_detect.enabled = true
	if left_wall_detect.is_colliding():
		_move_speed *= -1
		right_wall_detect.enabled = true
		left_wall_detect.enabled = false
