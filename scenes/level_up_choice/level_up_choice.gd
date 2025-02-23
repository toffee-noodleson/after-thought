extends Control
@onready var dagger_button: Button = $HBoxContainer/DaggerButton
@onready var axe_button: Button = $HBoxContainer/AxeButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_player_level_up.connect(on_player_level_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_player_level_up() -> void:
	show()
	get_tree().paused = true

func _on_dagger_button_pressed() -> void:
	print("upgrade dagger")
	if StatsDatabase.player_dagger_level < 5:
		StatsDatabase.player_dagger_level += 1
	else:
		dagger_button.disabled = true
	hide()
	get_tree().paused = false

func _on_axe_button_pressed() -> void:
	print("upgrade axe")
	if StatsDatabase.player_axe_level < 5:
		StatsDatabase.player_axe_level += 1
	else:
		axe_button.disabled = true
	hide()
	get_tree().paused = false
