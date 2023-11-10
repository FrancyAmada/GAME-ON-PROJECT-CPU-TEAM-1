extends CharacterBody2D

class_name Homeless

signal to_jobless

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var idle_timer: Timer = $IdleTimer
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var enemydetection_component: EnemyDetectionComponent = $EnemyDetectionComponent
@onready var coin_detection_component: CoinDetectionComponent = $CoinDetectionComponent
@onready var max_speed = velocity_component.max_speed
@onready var enemy: CharacterBody2D
@onready var coin: RigidBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2 = Vector2.RIGHT

var idle: bool = true
var new_direction: int = 0
var enemy_distance: float
var shooting_angle: float
var run_away: bool = false

var coin_distance: float

var target_animal: CharacterBody2D = null
var target_animal_distance: int = 1000
var animals_list: Array


func _ready():
	idle_timer.start()

func _physics_process(delta):
	on_idle()
	set_target_enemy()
	set_target_coin()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if idle:
		direction.x = new_direction
		velocity.x = direction.x * max_speed
	elif enemy != null:
		get_direction()
		velocity.x = direction.x * max_speed
	elif not idle:
		direction.x = 0
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	if coin:
		direction = (coin.global_position - global_position).normalized()
		velocity.x = direction.x * max_speed
	
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)

func get_direction():
	if enemy != null:
		direction = (enemy.global_position - global_position).normalized()
		if enemy_distance < 120 and not run_away:
			run_away = true
		elif enemy_distance > 200 and run_away:
			run_away = false
		elif run_away:
			direction.x = -direction.x

func on_idle():
	if enemy != null:
		idle = false
	elif idle_timer.is_stopped():
		idle = true
		idle_timer.start()

func _on_idle_timer_timeout():
	var choice: int = rng.randi_range(-1, 1)
	if idle:
		new_direction = choice
	
func set_target_enemy():
	var enemy_data = enemydetection_component.get_enemy()
	enemy = enemy_data[0]
	enemy_distance = enemy_data[1]

func set_target_coin():
	var coin_data = coin_detection_component.get_coin()
	coin = coin_data[0]
	coin_distance = coin_data[1]

func map_range(value: float, start1: float, stop1: float, start2: float, stop2: float):
	return (value - start1) / (stop1 - start1) * (stop2 - start2) + start2

func change_role():
	print("whaa????")
	to_jobless.emit()
