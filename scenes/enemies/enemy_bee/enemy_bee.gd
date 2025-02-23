extends EnemyBase

@onready var debug_label: Label = $DebugLabel
@onready var hit_box: Area2D = $HitBox
@onready var enemy_bee: CharacterBody2D = $"."

enum ENEMY_STATE {IDLE, WALK, ATTACK, HURT}

var _current_state: ENEMY_STATE
var _player_detected: bool = false
var _attack_speed: float = -50
var tween: Tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#call_deferred("detect_player")
	calculate_state()
	update_label()
	move()

func flip_actor() -> void:
	super.flip_actor()

func move() -> void:
	
	if _hit_stun:
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

func create_move_tween() -> void:
	tween = enemy_bee.create_tween()
	tween.tween_property(enemy_bee, "global_position", get_core_pos(), 10)
	#tween.tween_callback($Sprite.queue_free)

func update_label() -> void:
	debug_label.text = "hp: %d" % _current_hp

func get_core_pos() -> Vector2:
	return get_tree().get_nodes_in_group("core")[0].global_position

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Core":
		print("core hit by enemy")
		StatsDatabase.shared_current_hp -= 1
		SignalManager.on_core_hit.emit()
		queue_free()


func _on_move_timer_timeout() -> void:
	create_move_tween()
