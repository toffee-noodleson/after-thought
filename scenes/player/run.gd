extends State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func enter_state(player: CharacterBody2D, animation_player: AnimationPlayer) -> void:
	animation_player.play("run")


func exit_state() -> void:
	pass
