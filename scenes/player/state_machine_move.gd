extends Node2D

class_name StateMachineMove

enum MOVE_STATE {
	IDLE,
	RUN,
	JUMP,
	FALL
}

# cast current state and set to IDLE as starting default
var _current_state: MOVE_STATE = MOVE_STATE.IDLE

func enter_state(state: MOVE_STATE) -> void:
	pass

func exit_state(state: MOVE_STATE) -> void:
	pass

func update_state(desired_state: MOVE_STATE) -> void:
	if desired_state == _current_state:
		return

	exit_state(_current_state)
	enter_state(desired_state)
	_current_state = desired_state
