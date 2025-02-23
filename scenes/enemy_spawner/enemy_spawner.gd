extends Node2D
class_name EnemySpawner

@export var enemy_type: PackedScene
@export var face_right: bool = false
@export var max_spawn_time: float = 7

var min_spawn_time: float = 5

@onready var label: Label = $Label
@onready var spawn_timer: Timer = $SpawnTimer

var _enemy 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_player_level_up.connect(on_player_level_up)
	spawn_timer.start(randf_range(min_spawn_time, max_spawn_time))

func on_player_level_up() -> void:
	if not min_spawn_time == 1:
		min_spawn_time -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "%d" % spawn_timer.time_left


func _on_spawn_timer_timeout() -> void:
	_enemy = enemy_type.instantiate()
	
	if face_right:
		_enemy._flipped = true
	
	add_child(_enemy)
