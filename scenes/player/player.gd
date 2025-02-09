extends CharacterBody2D

@onready var state_machine_move: StateMachineMove = $StateMachineMove

@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurtbox: CollisionShape2D = $Hurtbox

const SPEED: float = 150.0
const MAX_SPEED: float = 0
const GRAVITY: float = 0
const JUMP_VELOCITY: float = -400.0
const MAX_FALL_SPEED: float = 0

func _physics_process(delta: float) -> void:
	
	# Apply gravity
	if not is_on_floor():
		#state_machine_move.set_state(state_machine_move.MOVE_STATE.FALL)
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state_machine_move.set_state(state_machine_move.MOVE_STATE.JUMP)
		velocity.y = JUMP_VELOCITY


	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		sprite_2d.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		sprite_2d.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	calculate_state()
	update_debug_label()
	move_and_slide()

func calculate_state() -> void:
	if is_on_floor() == true:
		if velocity.x == 0:
			state_machine_move.set_state(state_machine_move.MOVE_STATE.IDLE)
		else:
			state_machine_move.set_state(state_machine_move.MOVE_STATE.RUN)
	else:
		if velocity.y > 0:
			state_machine_move.set_state(state_machine_move.MOVE_STATE.FALL)
		else:
			state_machine_move.set_state(state_machine_move.MOVE_STATE.JUMP)

func update_debug_label() -> void:
	debug_label.text = "state: %s\nvel: %d, %d" % [
		state_machine_move.MOVE_STATE.keys()[state_machine_move.get_current_state()],
		velocity.x,
		velocity.y
		]
	
