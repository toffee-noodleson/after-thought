extends Node2D

@export var enemy_type: PackedScene
@export var face_right: bool = false
@export var spawn_time: float = 10

@onready var label: Label = $Label
@onready var spawn_timer: Timer = $SpawnTimer

var _enemy 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	spawn_timer.start(randf_range(5, spawn_time))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "%d" % spawn_timer.time_left


func _on_spawn_timer_timeout() -> void:
	_enemy = enemy_type.instantiate()
	
	if face_right:
		_enemy._flipped = true
	
	add_child(_enemy)
