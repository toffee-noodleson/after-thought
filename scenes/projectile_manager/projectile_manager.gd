extends Node2D

@onready var player: CharacterBody2D = $"../Player"
@onready var dagger_timer: Timer = $DaggerTimer

var dagger = preload("res://scenes/projectiles/dagger.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_projectile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dagger.move(delta)
	if Input.is_action_just_pressed("debug_spawn_projectile"):
		print("duplicate projectile")
		dagger.duplicate()

func get_parent_pos() -> Vector2:
	return get_parent().global_position


func reset(pos: Vector2) -> void:
	dagger.global_position = pos

func _on_dagger_timer_timeout() -> void:
	reset(player.global_position)

func spawn_projectile() -> void:
	add_child(dagger)
	dagger_timer.start(dagger.projectile.lifetime)
