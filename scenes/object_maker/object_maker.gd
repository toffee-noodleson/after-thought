extends Node2D

var enemy_death_scene: PackedScene = preload("res://scenes/enemies/enemy_death.tscn")
var gem_scene: PackedScene = preload("res://scenes/gem/gem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_enemy_death.connect(on_enemy_death)
	
	# TODO Placeholder animation until you actually make something
	SignalManager.on_projectile_enemy_hit.connect(on_enemy_hit)

func on_enemy_death(global_pos: Vector2) -> void:
	spawn_object(enemy_death_scene, global_pos)
	
	spawn_object(gem_scene, global_pos)

func on_enemy_hit(global_pos: Vector2) -> void:
	spawn_object(enemy_death_scene, global_pos)

func spawn_object(packed_scene: PackedScene, global_pos: Vector2) -> void:
	var object = packed_scene.instantiate()
	object.global_position = global_pos
	add_child(object)
	
	
