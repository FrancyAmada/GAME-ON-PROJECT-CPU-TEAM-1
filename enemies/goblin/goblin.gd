extends CharacterBody2D

class_name Goblin

@export var hit_state: State
@export var attack1_component: AttackComponent
@export var death_anim_name: String = "Death"
@onready var audio_stream_player = $AudioStreamPlayer


@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var enemydetection_component: EnemyDetectionComponent = $EnemyDetectionComponent
@onready var max_speed = velocity_component.max_speed
@onready var enemy: CharacterBody2D

var enemy_distance: float = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2 = Vector2.RIGHT

func _ready():
	animation_component.connect("animation_is_finished", _on_animation_component_finished)

func _physics_process(delta):
	set_target_enemy()
	
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
	
	var reversed_direction = Vector2(-direction.x, direction.y)
	
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(reversed_direction)

func get_direction():
	if !DayNight.is_day:
		if not attack1_component.check_if_enemy_is_detected():
			direction = (enemy.global_position - global_position).normalized()
		elif attack1_component.check_if_enemy_is_detected():
			direction.x = 0
	else:
		direction.x = -1
		
func set_target_enemy():
	var enemy_data = enemydetection_component.get_enemy()
	enemy = enemy_data[0]
	enemy_distance = enemy_data[1]

func _on_animation_component_finished(anim_name: String):
	if anim_name == death_anim_name:
		queue_free()

func _on_sound_body_entered(body):
	if body.name == "Player":
		audio_stream_player.play()
