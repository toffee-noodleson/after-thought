extends Node2D

class_name ProjectileManager

@onready var player: CharacterBody2D = $"../Player"
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var core: Sprite2D = $"../Core"
@onready var axe_cooldown_timer: Timer = $AxeCooldownTimer
@onready var dagger_cooldown_timer_2: Timer = $DaggerCooldownTimer2
@onready var axe_cooldown_timer_2: Timer = $AxeCooldownTimer2

var _dagger: ProjectileDagger
var _axe: ProjectileAxe
var _face_right: bool = true

var _dagger_freq: float = 1
var _axe_freq: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.player_face_right.connect(face_right)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_parent_pos() -> Vector2:
	return get_parent().global_position


func spawn_dagger() -> void:
	_dagger = load("res://scenes/projectiles/dagger.tscn").instantiate()
	_dagger.setup(player.global_position, _face_right, StatsDatabase.player_dagger_level)
	if not _dagger_freq == _dagger.projectile.frequency:
		dagger_cooldown_timer_2.start(_dagger.projectile.cooldown +0.2)
		_dagger_freq = _dagger.projectile.frequency
	call_deferred("add_child", _dagger)

func spawn_axe() -> void:
	_axe = load("res://scenes/axe/axe.tscn").instantiate()
	_axe.setup(player.global_position, _face_right, StatsDatabase.player_axe_level)
	if not _axe_freq == _axe.projectile.frequency:
		axe_cooldown_timer_2.start(_axe.projectile.cooldown +0.2)
		_axe_freq = _axe.projectile.frequency
	call_deferred("add_child", _axe)

func face_right(right: bool) -> void:
	if right:
		_face_right = true
	else:
		_face_right = false

func _on_cooldown_timer_timeout() -> void:
	spawn_dagger()
	cooldown_timer.start(_dagger.projectile.cooldown)

func _on_axe_cooldown_timer_timeout() -> void:
	spawn_axe()
	axe_cooldown_timer.start(_axe.projectile.cooldown)


func _on_dagger_cooldown_timer_2_timeout() -> void:
	spawn_dagger()

func _on_axe_cooldown_timer_2_timeout() -> void:
	spawn_axe()
