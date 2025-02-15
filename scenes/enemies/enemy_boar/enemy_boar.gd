extends EnemyBase

@onready var player_detect: RayCast2D = $PlayerDetect
@onready var wall_detect: RayCast2D = $WallDetect
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum ENEMY_STATE {IDLE, ATTACK, HURT, DEATH}

var _current_state: ENEMY_STATE
var _player_detected: bool = false
var _move_speed: float = -25
var _flipped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	call_deferred("detect_player")
	call_deferred("detect_wall")
	
	
	calculate_state(_current_state)
	
	# no conditions yet so using idle
	_current_state = ENEMY_STATE.IDLE

func _physics_process(delta: float) -> void:
	
	# apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	move()
	move_and_slide()

func move() -> void:
	velocity.x = _move_speed

func calculate_state(state: ENEMY_STATE) -> void:
	
	if state == _current_state:
		return
	
	match _current_state:
		ENEMY_STATE.IDLE:
			animated_sprite_2d.play("walk")

func detect_player() -> void:
	if player_detect.is_colliding():
		print("detect player")

func detect_wall() -> void:
	if is_on_wall() or wall_detect.is_colliding():
		flip_actor()

func flip_actor() -> void:
	if _flipped:
		animated_sprite_2d.flip_h = true
		player_detect.rotation_degrees = -90
		_move_speed = absf(_move_speed)
		_flipped = false
	else:
		animated_sprite_2d.flip_h = false
		player_detect.rotation_degrees = 90
		_move_speed *= -1
		_flipped = true
		
