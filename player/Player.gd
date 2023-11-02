extends CharacterBody2D

class_name Player

signal use_attack(attack_name: String)

@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var max_speed = velocity_component.max_speed

var interactable_object : Node2D = null

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var Coin = preload("res://collectables/coin.tscn")

var direction: Vector2


func _ready():
	set_process_input(true)

func _process(delta):
	Game.set_player_position(self.position)

var coin_dropped = false

var damageable = true

func _input(event):
	if event.is_action_pressed("ui_down") and interactable_object and Game.player_gold > 0:
		Signals.emit_signal("pass_coin")
	elif event.is_action_pressed("ui_down") and not coin_dropped and Game.player_gold > 0:
		Signals.emit_signal("remove_coin")
		coin_dropped = true

func _unhandled_input(event):
	if event.is_action_released("ui_down"):
		coin_dropped = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x and state_machine.check_if_can_move():
		velocity.x = direction.x * max_speed
	else:
		velocity.x = move_toward(velocity.x, 0, max_speed)
		
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)

func _on_area_2d_area_entered(object):
	if object.is_in_group("interactable"):
		interactable_object = object

func _on_area_2d_area_exited(object):
	if object.is_in_group("interactable"):
		interactable_object = null
