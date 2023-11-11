extends CharacterBody2D

class_name Player

@export var hit_state: HitState
@onready var audio_stream_player = $AudioStreamPlayer

@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var max_speed = velocity_component.max_speed
@onready var torch_light: PointLight2D = $Torchlight

var interactable_object : interactable_object = null

var Coin = preload("res://collectables/coin.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2

func _ready():
	set_process_input(true)

func _process(delta):
	Game.set_player_position(self.position)

var coin_dropped = false

var damageable = true

func _input(event):
	if event.is_action_pressed("ui_down") and interactable_object and Game.player_gold > 0 and interactable_object.coins_in < interactable_object.coins_needed:
		interactable_object._pass_coin()
		Signals.emit_signal("pass_coin")
	elif event.is_action_pressed("ui_down") and not coin_dropped and Game.player_gold > 0:
		Signals.emit_signal("remove_coin")
		coin_dropped = true

func _unhandled_input(event):
	if event.is_action_released("ui_down"):
		coin_dropped = false

func _physics_process(delta):
	get_light_for_night()
	
	if not is_on_floor():
		velocity.y += gravity * delta

	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x and state_machine.check_if_can_move():
		velocity.x = direction.x * max_speed
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	if direction.x == 0:
		audio_stream_player.stop()
	elif !audio_stream_player.is_playing():
		audio_stream_player.play()
		
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)

func _on_area_2d_area_entered(object):
	if object.is_in_group("interactable"):
		if interactable_object:
			interactable_object.close_coins_need()
			interactable_object = null
		interactable_object = object
		interactable_object.show_coins_need()

func _on_area_2d_area_exited(object):
	if object.is_in_group("interactable"):
		if interactable_object == object:
			interactable_object.close_coins_need()
			interactable_object = null

func _on_health_component_health_changed(node, health_change):
	if Game.player_gold > 0:
		Signals.emit_signal("remove_coin")
		coin_dropped = true

func get_light_for_night():
	if DayNight.transitioning_phase == true:
		if DayNight.is_day:
			torch_light.energy = 0.8
		else:
			torch_light.energy = 0
