extends CharacterBody2D

signal use_attack(attack_name: String)

@export var hit_state: State
@export var shoot_component: ShootComponent

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var idle_timer: Timer = $IdleTimer
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var enemydetection_component: EnemyDetectionComponent = $EnemyDetectionComponent
@onready var max_speed = velocity_component.max_speed
@onready var enemy: CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2 = Vector2.RIGHT

var idle: bool = true
var enemy_distance: float
var shooting_angle: float
var run_away: bool = false

func _physics_process(delta):
	set_target_enemy()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if enemy != null and state_machine.check_if_can_move():
		get_direction()
		velocity.x = direction.x * max_speed
	elif state_machine.current_state != hit_state:
		direction.x = 0
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)
	on_idle()

func get_direction():
	direction = (enemy.global_position - global_position).normalized()
	if enemy_distance < 150 and not run_away:
		set_shooting_angle()
		emit_signal("use_attack", "Shoot")
		run_away = true
	elif (enemy_distance > 250 and run_away) or shoot_component.check_if_can_use():
		run_away = false
	elif run_away:
		direction.x = -direction.x

func on_idle():
	if enemy == null:
		idle = true
		idle_timer.start()
	else:
		idle = false

func _on_idle_timer_timeout():
	if enemy == null:
		direction.x = rng.randi_range(-1, 1)
		idle_timer.start()
	
func set_target_enemy():
	var enemy_data = enemydetection_component.get_enemy()
	enemy = enemy_data[0]
	enemy_distance = enemy_data[1]
	
func set_shooting_angle():
	var initial_velocity = 500
	var angle = 0.5 * asin((gravity * enemy_distance * direction.x) / (initial_velocity ** 2))
	shooting_angle = rad2deg(angle)
	if enemy_distance * direction.x < 0:
		shooting_angle = 180 + shooting_angle
	
func rad2deg(rad):
	return rad * 180 / PI
	
