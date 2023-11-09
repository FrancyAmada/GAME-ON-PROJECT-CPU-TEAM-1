extends CharacterBody2D

class_name Boar

@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var playback: AnimationNodeStateMachinePlayback = animation_component.animation_tree["parameters/playback"]

# Health variable
@export var maxHp: float = 10
@onready var health: float = maxHp

@export var coin_amount: int = 1

const SPEED = 60.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2 = Vector2.ZERO

var delta_time: float = 0.0


func _ready():
	animation_component.connect("animation_is_finished", _on_animation_component_finished)

func _physics_process(delta):
	delta_time += delta
	
	if delta_time >= 2:
		delta_time = 0
		get_direction()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var reversed_direction = Vector2(-direction.x, direction.y)
	
	move_and_slide()
	animation_component.update_animation(reversed_direction)
	animation_component.update_facing_direction(reversed_direction)

func get_direction():
	var choice_move = randi_range(-1, 1)
	direction.x = choice_move
	
func get_hit(damage: float):
	health -= damage
	if health <= 0:
		die()
		
func die():
	set_physics_process(false)
	playback.travel("Death")

func _on_animation_component_finished(anim_name: String):
	if anim_name == "Death":
		Signals.emit_signal("generate_coin", self, coin_amount)
		queue_free()
