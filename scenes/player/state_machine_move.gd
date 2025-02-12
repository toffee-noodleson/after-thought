extends Node2D

class_name StateMachineMove
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

@onready var idle: Node2D = $Idle
@onready var run: Node2D = $Run
@onready var jump: Node2D = $Jump
@onready var fall: Node2D = $Fall
@onready var attack_1: Node2D = $Attack_1

# To add a new state, must add new enum value to MOVE_STATE and then map to new node state script in 
# _move_state_script_mapping dictionary

enum MOVE_STATE {
	IDLE,
	RUN,
	JUMP,
	FALL,
	ATTACK_1
}

var _move_state_script: Dictionary = {}

func _ready() -> void:
	_move_state_script = {
	MOVE_STATE.IDLE: idle,
	MOVE_STATE.RUN: run,
	MOVE_STATE.JUMP: jump,
	MOVE_STATE.FALL: fall,
	MOVE_STATE.ATTACK_1: attack_1
	}

# cast current state and set to IDLE as starting default
var _current_state: MOVE_STATE

@onready var player: CharacterBody2D = $".."

#func enter_state(state: MOVE_STATE) -> void:
	#pass
#
#func exit_state(state: MOVE_STATE) -> void:
	#pass

func get_current_state() -> MOVE_STATE:
	return _current_state

func set_state(desired_state: MOVE_STATE) -> void:
	if desired_state == _current_state:
		return
	
	# Run exit state function from current state. Accessed via dictionary
	#_move_state_script._current_state.exit_state()
	
	# Run enter state function from desired state
	_move_state_script[desired_state].enter_state(player, animation_player)
	
	# Set new current state
	_current_state = desired_state
