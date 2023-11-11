extends CharacterBody2D

class_name Breeder

@export var hit_state: State
@export var attack1_component: AttackComponent
@export var spawn_amount: int = 3
@export var death_anim_name: String = "Death"

@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var enemydetection_component: EnemyDetectionComponent = $EnemyDetectionComponent
@onready var breed_timer: Timer = $BreedTimer
@onready var max_speed = velocity_component.max_speed
@onready var enemy: CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2 = Vector2.RIGHT

var goblin = preload("res://enemies/goblin/goblin.tscn")

var enemy_distance: float = 0


func _ready():
	animation_component.connect("animation_is_finished", _on_animation_component_finished)
	breed_timer.connect("timeout", _on_breed_timer_timeout)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if enemy == null:
		if !DayNight.is_day:
			direction.x = 1
		else:
			direction.x = -1
	
	if enemy != null and state_machine.check_if_can_move():
		get_direction()
		velocity.x = direction.x * max_speed
	elif state_machine.current_state != hit_state:
		direction.x = 0
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)

func get_direction():
	if !DayNight.is_day:
		if not attack1_component.check_if_enemy_is_detected():
			direction = (enemy.global_position - global_position).normalized()
		else:
			direction.x = 0
	else:
		direction.x = -1
		
func set_target_enemy():
	var enemy_data = enemydetection_component.get_enemy()
	enemy = enemy_data[0]
	enemy_distance = enemy_data[1]

func _on_breed_timer_timeout():
	for spawn in range(spawn_amount):
		var new_goblin: Goblin = goblin.instantiate()
		get_parent().add_child(new_goblin)
		new_goblin.global_position = self.position
		new_goblin.global_position.x += spawn * -10
	breed_timer.start()

func _on_animation_component_finished(anim_name: String):
	if anim_name == death_anim_name:
		queue_free()
		
