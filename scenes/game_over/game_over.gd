extends Control
@onready var button: Button = $VBoxContainer/HBoxContainer/Button



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_player_death.connect(on_player_death)


func on_player_death() -> void:
	show()
	get_tree().paused = true

func _on_button_pressed() -> void:
	hide()
	get_tree().paused = false
	get_tree().reload_current_scene()
