extends CharacterBody2D
class_name EnemyBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_stun_timer: Timer = $HitStunTimer
@onready var sword_invincible_timer: Timer = $SwordInvincibleTimer

@export var _hit_points: float
@export var _damage: float
@export var _move_speed: float

var _current_hp: float
var _flipped: bool = false
var _hit_stun: bool = false
var _invincible: bool = false
var _sword_invincibile: bool = false

func _ready() -> void:
	_current_hp = _hit_points
	if _flipped:
		flip_actor()



func flip_actor() -> void:
	if animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = false

	else:
		animated_sprite_2d.flip_h = true

	_move_speed *= -1

func take_damage(damage: float) -> void:
	_current_hp -= damage
	check_death()

func check_death() -> void:
	if _current_hp <= 0:
		SignalManager.on_enemy_death.emit(global_position)
		queue_free()


func _on_hit_stun_timer_timeout() -> void:
	_hit_stun = false

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
