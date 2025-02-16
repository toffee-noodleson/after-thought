extends Node2D

class_name ProjectileManager

@onready var player: CharacterBody2D = $"../Player"
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var core: Sprite2D = $"../Core"

var _dagger: ProjectileDagger
var _face_right: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.player_face_right.connect(face_right)
	spawn_dagger()
	cooldown_timer.start(_dagger.projectile.cooldown)
	
	# Populate autoload damage dictionary
	StatsDatabase.projectile_damage["dagger"] = _dagger.projectile.damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_parent_pos() -> Vector2:
	return get_parent().global_position


func spawn_dagger() -> void:
	_dagger = preload("res://scenes/projectiles/dagger.tscn").instantiate()
	_dagger.setup(core.global_position, _face_right)
	call_deferred("add_child", _dagger)

func face_right(right: bool) -> void:
	if right:
		_face_right = true
	else:
		_face_right = false
	


func _on_cooldown_timer_timeout() -> void:
	spawn_dagger()
