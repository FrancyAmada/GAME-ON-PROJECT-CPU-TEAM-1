extends CharacterBody2D

class_name Goblin

@export var hit_state: State
@export var attack1_component: AttackComponent

@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var playerdetection_component: PlayerDetectionComponent = $PlayerDetectionComponent
@onready var max_speed = velocity_component.max_speed
@onready var player: CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2 = Vector2.RIGHT


func _ready():
	playerdetection_component.connect("chase_player", set_chase_player)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if player != null and state_machine.check_if_can_move():
		get_direction()
		velocity.x = direction.x * max_speed
	elif state_machine.current_state != hit_state:
		direction.x = 0
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)

func get_direction():
	for child in player.get_children():
		if child is HitBoxComponent:
			if child.health_component.health >= 0 and not attack1_component.check_if_enemy_is_detected():
				direction.x = sign((player.position - position).x)
			else:
				direction.x = 0

func set_chase_player(set_player: CharacterBody2D):
	player = set_player
	
