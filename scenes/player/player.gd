extends CharacterBody2D

@onready var state_machine_move: StateMachineMove = $StateMachineMove
@onready var debug_label: Label = $DebugLabel

const SPEED = 200.0
const MAX_SPEED = 0
const MOVE_FRICTION = 0
const JUMP_VELOCITY = -400.0
const MAX_FALL_SPEED = 0


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		state_machine_move.update_state(state_machine_move.MOVE_STATE.FALL)
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	if Input.is_action_pressed("right"):
		velocity.x = SPEED
	elif Input.is_action_pressed("left"):
		velocity.x = -1 * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	update_debug_label()
	move_and_slide()

func update_debug_label() -> void:
	debug_label.text = "state: %s" % state_machine_move.MOVE_STATE.keys()[state_machine_move._current_state]
