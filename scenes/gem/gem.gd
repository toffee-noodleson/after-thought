extends AnimatedSprite2D

@export var _xp: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func pick_up() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	SignalManager.on_gem_pickup.emit(_xp)
	pick_up()
