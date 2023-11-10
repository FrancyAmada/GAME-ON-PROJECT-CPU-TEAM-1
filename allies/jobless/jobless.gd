extends CharacterBody2D

class_name Jobless

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var idle_timer: Timer = $IdleTimer
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var enemydetection_component: EnemyDetectionComponent = $EnemyDetectionComponent
@onready var tool_detection_component: ToolDetectionComponent = $ToolDetectionComponent
@onready var max_speed = velocity_component.max_speed
@onready var enemy: CharacterBody2D
@onready var tool: RigidBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2 = Vector2.RIGHT

var idle: bool = true
var new_direction: int = 0
var enemy_distance: float
var shooting_angle: float
var run_away: bool = false

var tool_distance: float

var target_animal: CharacterBody2D = null
var target_animal_distance: int = 1000
var animals_list: Array


func _ready():
	idle_timer.start()

func _physics_process(delta):
	on_idle()
	set_target_enemy()
	set_target_tool()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if idle and !tool:
		direction.x = new_direction
		velocity.x = direction.x * max_speed
	elif enemy != null:
		get_direction()
		velocity.x = direction.x * max_speed
	elif not idle:
		direction.x = 0
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	if tool:
		direction = (tool.global_position - global_position).normalized()
		velocity.x = direction.x * max_speed
	
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)

func get_direction():
	if enemy != null:
		if enemy_distance < 150 and not run_away:
			run_away = true
		elif enemy_distance > 250 and run_away:
			run_away = false
		elif run_away:
			direction.x = -sign(enemy.global_position.x - global_position.x)

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

func set_target_tool():
	var tool_data = tool_detection_component.get_tool()
	tool = tool_data[0]
	tool_distance = tool_data[1]

func map_range(value: float, start1: float, stop1: float, start2: float, stop2: float):
	return (value - start1) / (stop1 - start1) * (stop2 - start2) + start2

func sayhi():
	print("hi")
