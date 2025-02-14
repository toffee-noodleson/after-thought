class_name ProjectileDagger

extends Sprite2D

@export var projectile: ProjectileRes = preload("res://projectile_resource/dagger.tres")

@onready var lifespan_timer: Timer = $LifespanTimer

var _starting_global: Vector2
var _face_right: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = _starting_global
	lifespan_timer.start(projectile.cooldown)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	if _face_right:
		global_position.x += projectile.speed * delta
	else:
		global_position.x -= projectile.speed * delta
	global_position.y = _starting_global.y
	
	
func reset(pos: Vector2) -> void:
	global_position = pos
	_starting_global = pos

func setup(pos: Vector2, face_right: bool) -> void:
	_starting_global = pos
	_face_right = face_right
	
	if !face_right:
		flip_h = true
	else:
		flip_h = false
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	SignalManager.on_projectile_enemy_hit.emit()


func _on_lifespan_timer_timeout() -> void:
	queue_free()
