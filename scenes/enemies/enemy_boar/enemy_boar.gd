extends EnemyBase

@onready var player_detect: RayCast2D = $PlayerDetect
@onready var wall_detect: RayCast2D = $WallDetect
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var debug_label: Label = $DebugLabel
@onready var sword_invincible_timer: Timer = $SwordInvincibleTimer
@onready var hit_stun_timer: Timer = $HitStunTimer


enum ENEMY_STATE {IDLE, WALK, ATTACK, HURT, DEATH}

var _current_state: ENEMY_STATE
var _player_detected: bool = false
var _move_speed: float = -25
var _attack_speed: float = -50
var _flipped: bool = false
var _current_hp: float
var _sword_invincibile: bool = false
var _invincible: bool = false
var _hit_stun: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_current_hp = _hit_points
	if _flipped:
		flip_actor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#call_deferred("detect_player")
	calculate_state()
	update_label()
	

func _physics_process(delta: float) -> void:
	detect_wall()
	# apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	move()
	move_and_slide()

func move() -> void:
	
	if _hit_stun:
		velocity.x = 0
		return
	
	velocity.x = _move_speed

func attack() -> void:
	velocity.x = _attack_speed

func calculate_state() -> void:
	
	if _hit_stun:
		set_state(ENEMY_STATE.HURT)
		return 
	
	if velocity.x != 0 and _current_state != ENEMY_STATE.ATTACK:
		set_state(ENEMY_STATE.WALK)
	else:
		set_state(ENEMY_STATE.IDLE)


func set_state(state: ENEMY_STATE) -> void:
	
	if state == _current_state:
		return
	
	_current_state = state
	
	match _current_state:
		ENEMY_STATE.IDLE:
			animated_sprite_2d.play("idle")
		ENEMY_STATE.WALK:
			animated_sprite_2d.play("walk")
		ENEMY_STATE.HURT:
			animated_sprite_2d.play("hit")
			hit_stun_timer.start()


func detect_player() -> void:
	if player_detect.is_colliding():
		print("detect player")

func detect_wall() -> void:
	if is_on_wall() or wall_detect.is_colliding():
		flip_actor()

func flip_actor() -> void:
	if animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = false

	else:
		animated_sprite_2d.flip_h = true

	player_detect.rotate(PI)
	wall_detect.rotate(PI)
	_move_speed *= -1
	_attack_speed *= -1

func take_damage(damage: float) -> void:
	_current_hp -= damage
	check_death()

func update_label() -> void:
	debug_label.text = "hp: %d" % _current_hp


func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	if _invincible:
		return
	
	
	# Need to refactor daggers into a base class to match projectile group. For now just
	# cheat and match exact type
	if "projectile" in area.get_parent().get_groups():
		_hit_stun = true
		take_damage(area.get_parent()._damage)

	if area.name == "HitboxAttack1":
		if not _sword_invincibile:
			take_damage(area.get_parent().get_parent()._damage)
			_sword_invincibile = true
			sword_invincible_timer.start()

func _on_sword_invincible_timer_timeout() -> void:
	_sword_invincibile = false

func check_death() -> void:
	if _current_hp <= 0:
		SignalManager.on_enemy_death.emit(global_position)
		queue_free()


func _on_hit_stun_timer_timeout() -> void:
	_hit_stun = false
	set_state(ENEMY_STATE.IDLE)
	

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Core":
		print("core hit by enemy")
		StatsDatabase.current_hp -= 1
		SignalManager.on_core_hit.emit()
		queue_free()
