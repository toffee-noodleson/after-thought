class_name ProjectileDagger

extends Sprite2D

@export var projectile: ProjectileRes = preload("res://projectile_resource/dagger.tres")

var _starting_global: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move(delta: float) -> void:
	global_position.x += projectile.speed * delta

func reset(pos: Vector2) -> void:
	global_position = pos
	_starting_global.y = global_position.y

func _on_area_2d_area_entered(area: Area2D) -> void:
	SignalManager.on_projectile_enemy_hit.emit()
