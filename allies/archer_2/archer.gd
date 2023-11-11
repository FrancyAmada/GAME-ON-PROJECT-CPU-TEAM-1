extends CharacterBody2D

class_name Archer

signal use_attack(attack_name: String)

var bow = preload("res://props/bow_despawnable.tscn")

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
@onready var hit = $CharacterStateMachine/Hit
@onready var hunt_area: Area2D = $HuntArea

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2 = Vector2.RIGHT

var idle: bool = true
var new_direction: int = 0
var enemy_distance: float
var shooting_angle: float
var run_away: bool = false

var target_animal: CharacterBody2D = null
var target_animal_distance: int = 1000
var animals_list: Array

func _ready():
	idle_timer.start()
	hit.dropBow.connect(printMe)

func _physics_process(delta):
	on_idle()
	set_target_enemy()
	get_target_animal()
	
	if enemy == null:
		hunt_area.monitoring = true
		if target_animal != null:
			enemy = target_animal
			enemy_distance = target_animal_distance
	else:
		hunt_area.monitoring = false
		target_animal = null
	
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
		if enemy_distance < 200 and not run_away:
			set_shooting_angle()
			emit_signal("use_attack", "Shoot")
			run_away = true
		elif (enemy_distance > 250 and run_away) or shoot_component.check_if_can_use():
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
	var height: float = 0.8
	
	if enemy.is_in_group("enemy"):
		height = 1.0
	
	# Just for testing only
	var range_multiplier = map_range(enemy_distance, 200, 0, height, 0.5)
	
	var angle = range_multiplier * asin((gravity * enemy_distance * direction.x) / (initial_velocity ** 2))
	shooting_angle = rad2deg(angle)
	if enemy_distance * direction.x < 0:
		shooting_angle = 180 + shooting_angle
	
func rad2deg(rad):
	return rad * 180 / PI
	
func map_range(value: float, start1: float, stop1: float, start2: float, stop2: float):
	return (value - start1) / (stop1 - start1) * (stop2 - start2) + start2

func printMe():
	var new_bow = bow.instantiate()
	add_child(new_bow)
	var velocity_x = randi_range(-140, 140)
	var newVelocity = Vector2(velocity_x, -130)
	new_bow.set_linear_velocity(newVelocity)
	new_bow.global_position = self.position + Vector2(0, -35)
	await get_tree().create_timer(.6).timeout
	queue_free()

func get_target_animal():
	target_animal = null
	var nearest_distance: int = 1000
	for animal in animals_list:
		var animal_distance = abs(global_position.x - animal.global_position.x)
		if animal_distance < nearest_distance:
			nearest_distance = animal_distance
			target_animal = animal
			target_animal_distance = animal_distance
	
func _on_hunt_area_body_entered(body):
	if body.is_in_group("animals"):
		animals_list.append(body)

func _on_hunt_area_body_exited(body):
	if body in animals_list:
		animals_list.erase(body)
