extends EnemySpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.start(10)
