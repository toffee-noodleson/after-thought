class_name ProjectileDagger

extends Sprite2D

@onready var lifespan_timer: Timer = $LifespanTimer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var projectile: ProjectileRes = preload("res://projectile_resource/dagger/dagger_1.tres")
var _starting_global: Vector2
var _face_right: bool = true
var _damage: float
var _rand_y: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = _starting_global
	lifespan_timer.start(projectile.lifetime)
	_damage = projectile.damage
	_rand_y = randf_range(-5, 5)
	
	SoundManager.play_clip(audio_stream_player_2d, "knife")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	if _face_right:
		global_position.x += projectile.speed * delta
	else:
		global_position.x -= projectile.speed * delta
	global_position.y = _starting_global.y + _rand_y
	
	
func reset(pos: Vector2) -> void:
	global_position = pos
	_starting_global = pos

func setup(pos: Vector2, face_right: bool, projectile_lvl) -> void:
	if projectile:
		projectile = load("res://projectile_resource/dagger/dagger_%s.tres" % projectile_lvl)
	_starting_global = pos
	_face_right = face_right
	
	if !face_right:
		flip_h = true
	else:
		flip_h = false

func exit_scene() -> void:
	queue_free()

func _on_lifespan_timer_timeout() -> void:
	exit_scene()

func _on_area_2d_area_entered(area: Area2D) -> void:
	SignalManager.on_projectile_enemy_hit.emit(global_position)
	exit_scene()
