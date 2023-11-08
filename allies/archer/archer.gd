class_name archer
extends CharacterBody2D

signal animation_is_finished(anim_name: String)

var arrow = preload("res://projectiles/arrow.tscn")

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_sprite : Sprite2D = $Sprite2D
@onready var finite_state_machine_archer = $finiteStateMachine_archer as finiteStateMachine_archer
@onready var idle = $finiteStateMachine_archer/idle as archer_idle_state
@onready var shoot = $finiteStateMachine_archer/shoot as archer_shoot_state

var enemy_distance: float
var shooting_angle: float

const SPEED = 50.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_tree.active = true
	idle.start_shooting.connect(finite_state_machine_archer.changeState.bind(shoot))
	idle.start_shooting.connect(shoot_arrow)
	shoot.stop_shooting.connect(finite_state_machine_archer.changeState.bind(idle))

func set_shooting_angle():
	var initial_velocity = 500
	var angle = 0.5 * asin((gravity * enemy_distance) / (initial_velocity ** 2))
	shooting_angle = rad2deg(angle)
	if enemy_distance < 0:
		shooting_angle = 180 + shooting_angle

func rad2deg(rad):
	return rad * 180 / PI

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	animation_tree.set("parameters/move/blend_position", direction)
	
	if direction > 0:
		animation_sprite.flip_h = false
	elif direction < 0:
		animation_sprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	set_shooting_angle()
	move_and_slide()

func _on_animation_tree_animation_finished(anim_name):
	emit_signal("animation_is_finished", anim_name)

func shoot_arrow():
	var new_arrow = arrow.instantiate()
	new_arrow.angle = shooting_angle
	add_child(new_arrow)
	new_arrow = new_arrow.duplicate()
	new_arrow.global_position = self.position
