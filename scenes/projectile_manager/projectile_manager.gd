extends Node2D

@onready var player: CharacterBody2D = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_spawn_projectile"):
		spawn_dagger()

#func get_parent_pos() -> Vector2:
	#return get_parent().global_position


func reset(dagger: ProjectileDagger, pos: Vector2) -> void:
	dagger.global_position = pos

func spawn_dagger() -> void:
	var dagger: ProjectileDagger = preload("res://scenes/projectiles/dagger.tscn").instantiate()
	call_deferred("add_child")
