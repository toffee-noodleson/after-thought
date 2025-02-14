extends CharacterBody2D

@onready var sms: StateMachineMove = $StateMachineMove

@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurtbox: CollisionShape2D = $Hurtbox
@onready var dash_timer: Timer = $DashTimer
@onready var hitbox_attack_1: Area2D = $Sprite2D/HitboxAttack1
@onready var hitbox_attack_2: Area2D = $Sprite2D/HitboxAttack2

const SPEED: float = 150.0
const MAX_SPEED: float = 0
const GRAVITY: float = 0
const JUMP_VELOCITY: float = -400.0
const MAX_FALL_SPEED: float = 500.0
const DASH_TIME: float = 1.0
const DASH_POWER: float = 1200.0

var _can_jump: bool = true
var _can_dash: bool = true

var _pause_gravity: bool = false
var _pause_input: bool = false

func _physics_process(delta: float) -> void:
	
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = clamp(velocity.y, JUMP_VELOCITY, MAX_FALL_SPEED)

	# Apply horizontal friction
	velocity.x = move_toward(velocity.x, 0, SPEED)

	get_input()
	calculate_state()
	
	move_and_slide()

func _process(delta: float) -> void:
	update_debug_label()

func get_input() -> void:
	
	if _pause_input:
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("right"):
		SignalManager.player_face_right.emit(true)
		velocity.x = SPEED
		sprite_2d.flip_h = false
	elif Input.is_action_pressed("left"):
		SignalManager.player_face_right.emit(false)
		velocity.x = -SPEED
		sprite_2d.flip_h = true
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("attack"):
		#var input_direction = Input.get_vector("left", "right", "up", "down")
		flip_h_hitbox(hitbox_attack_1)
		if sprite_2d.flip_h:
			velocity = DASH_POWER * Vector2.LEFT
		else:
			velocity = DASH_POWER * Vector2.RIGHT
		sms.set_state(sms.MOVE_STATE.ATTACK_1)
		_pause_input = true
		dash_timer.start()

func calculate_state() -> void:
	
	if sms.get_current_state() == sms.MOVE_STATE.ATTACK_1:
		return
	
	if is_on_floor() == true:
		if velocity.x == 0:
			sms.set_state(sms.MOVE_STATE.IDLE)
		else:
			sms.set_state(sms.MOVE_STATE.RUN)
	else:
		if velocity.y > 0:
			sms.set_state(sms.MOVE_STATE.FALL)
		else:
			sms.set_state(sms.MOVE_STATE.JUMP)

func update_debug_label() -> void:
	debug_label.text = "state: %s\nvel: %d, %d" % [
		sms.MOVE_STATE.keys()[sms.get_current_state()],
		velocity.x,
		velocity.y
		]

func flip_h_hitbox(hitbox: Area2D) -> void:
	if sprite_2d.flip_h:
		hitbox.scale.x = -1
	else:
		hitbox.scale.x = 1

func _on_dash_timer_timeout() -> void:
	sms.set_state(sms.MOVE_STATE.IDLE)
	_pause_input = false
