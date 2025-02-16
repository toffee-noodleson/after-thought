extends Node2D

var enemy_death_scene: PackedScene = preload("res://scenes/enemies/enemy_death.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_enemy_death.connect(on_enemy_death)
	
	# TODO Placeholder animation until you actually make something
	SignalManager.on_projectile_enemy_hit.connect(on_enemy_death)

func on_enemy_death(global_pos: Vector2) -> void:
	var enemy_death = enemy_death_scene.instantiate()
	enemy_death.global_position = global_pos
	add_child(enemy_death)
