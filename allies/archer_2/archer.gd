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
var new_direction: int = 0
var enemy_distance: float
var shooting_angle: float
var run_away: bool = false

func _ready():
	idle_timer.start()

func _physics_process(delta):
	on_idle()
	set_target_enemy()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if idle:
		direction.x = new_direction
		velocity.x = direction.x * max_speed
	elif enemy != null and state_machine.check_if_can_move():
		get_direction()
		velocity.x = direction.x * max_speed
	elif state_machine.current_state != hit_state and not idle:
		direction.x = 0
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)

func get_direction():
	if enemy != null:
		direction = (enemy.global_position - global_position).normalized()
		if enemy_distance < 120 and not run_away:
			set_shooting_angle()
			emit_signal("use_attack", "Shoot")
			run_away = true
		elif (enemy_distance > 200 and run_away) or shoot_component.check_if_can_use():
			run_away = false
		elif run_away:
			direction.x = -direction.x
#	print_debug(enemy_distance)

func on_idle():
	if enemy != null:
		idle = false
	elif idle_timer.is_stopped():
		idle = true
		idle_timer.start()
#	print_debug(idle, enemy)

func _on_idle_timer_timeout():
	var choice: int = rng.randi_range(-1, 1)
	if idle:
		new_direction = choice
#		print_debug("Idle Direction : " + str(new_direction))
	
func set_target_enemy():
	var enemy_data = enemydetection_component.get_enemy()
	enemy = enemy_data[0]
	enemy_distance = enemy_data[1]
	
func set_shooting_angle():
	var initial_velocity = 500
	
	# Just for testing only
	var range_multiplier = map_range(enemy_distance, 200, 0, 1.0, 0.5)
	
	var angle = range_multiplier * asin((gravity * enemy_distance * direction.x) / (initial_velocity ** 2))
	shooting_angle = rad2deg(angle)
	if enemy_distance * direction.x < 0:
		shooting_angle = 180 + shooting_angle
	
func rad2deg(rad):
	return rad * 180 / PI
	
func map_range(value: float, start1: float, stop1: float, start2: float, stop2: float):
	return (value - start1) / (stop1 - start1) * (stop2 - start2) + start2
