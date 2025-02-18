extends Control

@onready var stopwatch_label: Label = $MarginContainer/StopwatchLabel

var time_elapsed: float = 0.0
var is_stopped: bool= false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_stopped:
		time_elapsed += delta
		stopwatch_label.text = "%d" % time_elapsed
