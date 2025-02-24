extends CharacterBody2D

@onready var sms: StateMachineMove = $StateMachineMove

@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var hitbox_attack_1: Area2D = $Sprite2D/HitboxAttack1
@onready var hitbox_attack_2: Area2D = $Sprite2D/HitboxAttack2
@onready var hurt_box: Area2D = $HurtBox
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


const SPEED: float = 150.0
const MAX_SPEED: float = 0
const GRAVITY: float = 0
const JUMP_VELOCITY: float = -400.0
const MAX_FALL_SPEED: float = 500.0
const DASH_TIME: float = 1.0
const DASH_POWER: float = 500.0

var _can_jump: bool = true
var _can_dash: bool = true

var _pause_gravity: bool = false
var _pause_input: bool = false
var _invincible: bool = false

var _damage: float = 3

func _ready() -> void:
	SignalManager.on_gem_pickup.connect(on_gem_pickup)
	SignalManager.on_core_hit.connect(on_core_hit)
	StatsDatabase.xp_next_level = Constants.XP_REQUIRED[1]

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
	level_up_handler()
	update_debug_label()

func level_up_handler() -> void:
	if StatsDatabase.player_current_level == 10:
		return
	if StatsDatabase.player_xp >= StatsDatabase.xp_next_level:
		SignalManager.on_player_level_up.emit()
		StatsDatabase.player_xp = 0
		StatsDatabase.player_current_level += 1
		StatsDatabase.xp_next_level = Constants.XP_REQUIRED[StatsDatabase.player_current_level]

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
		SoundManager.play_clip(audio_stream_player_2d, "blade")
		_pause_input = true
		dash_timer.start()

func calculate_state() -> void:
	
	if sms.get_current_state() == sms.MOVE_STATE.ATTACK_1:
		return
	
	if sms.get_current_state() == sms.MOVE_STATE.HURT:
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
	debug_label.text = "hp: %d/%d \nxp: %d/%d\ndag: %d axe: %d" % [
		StatsDatabase.shared_current_hp, Constants.TOTAL_HP,
		StatsDatabase.player_xp, StatsDatabase.xp_next_level,
		StatsDatabase.player_dagger_level, StatsDatabase.player_axe_level
		]
	#debug_label.text = "state: %s\nhp: %d/%d xp: %d" % [
		#sms.MOVE_STATE.keys()[sms.get_current_state()],
		#StatsDatabase.shared_current_hp, Constants.TOTAL_HP,
		#StatsDatabase.player_xp
		#]

func flip_h_hitbox(hitbox: Area2D) -> void:
	if sprite_2d.flip_h:
		hitbox.scale.x = -1
	else:
		hitbox.scale.x = 1

func check_death() -> void:
	if StatsDatabase.shared_current_hp <= 0:
		print("GAME OVER")
		SignalManager.on_player_death.emit()
		get_tree().paused = true

func take_damage() -> void:
	check_death()
	
	if _invincible:
		return
	
	SoundManager.play_clip(audio_stream_player_2d, "core_damage")
	velocity = Vector2.ZERO
	hitbox_attack_1.visible = false
	set_deferred("hitbox_attack_1.monitoring", false)
	set_deferred("hitbox_attack_1.monitorable", false)
	_invincible = true
	sms.set_state(sms.MOVE_STATE.HURT)
	StatsDatabase.shared_current_hp -= 1
	invincibility_timer.start()

func actor_reset() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 1)
	sms.set_state(sms.MOVE_STATE.IDLE)

func on_core_hit() -> void:
	SoundManager.play_clip(audio_stream_player_2d, "core_damage")
	check_death()

func _on_dash_timer_timeout() -> void:
	sms.set_state(sms.MOVE_STATE.IDLE)
	_pause_input = false


func _on_hitbox_attack_1_area_entered(area: Area2D) -> void:
	print("attack_1 hit")
	_damage = 3
	SignalManager.on_attack_1_enemy_hit.emit()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	take_damage()


func _on_invincibility_timer_timeout() -> void:
	_invincible = false
	actor_reset()

func on_gem_pickup(xp: float) -> void:
	SoundManager.play_clip(audio_stream_player_2d, "pickup")
	StatsDatabase.player_xp += xp
