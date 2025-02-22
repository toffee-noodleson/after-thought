extends CharacterBody2D
class_name ProjectileAxe

@onready var lifespan_timer: Timer = $LifespanTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var projectile: ProjectileRes = preload("res://projectile_resource/axe/axe_1.tres")
var _starting_global: Vector2
var _face_right: bool = true
var _damage: float
var _velocity_y: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = _starting_global
	lifespan_timer.start(projectile.lifetime)
	_damage = projectile.damage
	velocity.y = -500
	
	if !_face_right:
		animation_player.play("rotate_2")
		velocity.x = projectile.speed * -1
	else:
		velocity.x = projectile.speed
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#move(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func move(delta: float) -> void:
	if _face_right:
		velocity.y = projectile.speed * delta
	#else:
		#global_position.x -= projectile.speed * delta
	#global_position.y = _starting_global.y
	

func setup(pos: Vector2, face_right: bool, projectile_lvl) -> void:
	if projectile:
		projectile = load("res://projectile_resource/axe/axe_%s.tres" % projectile_lvl)
	_starting_global = pos
	_face_right = face_right
	
	if !face_right:
		scale.x *= -1
		

func exit_scene() -> void:
	queue_free()

func _on_lifespan_timer_timeout() -> void:
	exit_scene()

func _on_area_2d_area_entered(area: Area2D) -> void:
	SignalManager.on_projectile_enemy_hit.emit(global_position)
	exit_scene()
