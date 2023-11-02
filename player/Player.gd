extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var interactable_object : Node2D = null

@onready var anim = get_node("AnimationPlayer")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var Coin = preload("res://collectables/coin.tscn")

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

	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
		anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("idle")
		
	move_and_slide()

func _on_area_2d_area_entered(object):
	if object.is_in_group("interactable"):
		interactable_object = object

func _on_area_2d_area_exited(object):
	if object.is_in_group("interactable"):
		interactable_object = null
