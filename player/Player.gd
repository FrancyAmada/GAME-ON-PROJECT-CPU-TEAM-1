extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = get_node("AnimationPlayer")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var Coin = preload("res://collectables/coin.tscn")

func _ready():
	set_process_input(true)

func _process(delta):
	Game.set_player_position(self.position)

var coinDropped = false

func _input(event):
	if event.is_action_pressed("ui_down") and not coinDropped and Game.player_gold > 0:
		Signals.emit_signal("removeCoin")
		coinDropped = true

func _unhandled_input(event):
	if event.is_action_released("ui_down"):
		coinDropped = false

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
