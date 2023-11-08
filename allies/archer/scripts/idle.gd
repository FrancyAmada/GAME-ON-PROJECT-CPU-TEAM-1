class_name archer_idle_state
extends NodeState_archer

signal start_shooting

@export var actor : archer
@onready var animation_tree : AnimationTree = $"../../AnimationTree"
@onready var animation_sprite : Sprite2D = $"../../Sprite2D"
var SPEED : int
var time_elapsed = 0
var direction = 0

func _ready():
	SPEED = actor.SPEED
	animation_tree.active = true

func _enter_state():
	animation_tree["parameters/conditions/dies"] = false
	animation_tree["parameters/conditions/not_shooting"] = true
	animation_tree["parameters/conditions/shoot"] = false
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	time_elapsed += delta
	
	if time_elapsed >= 2:
		var randomValue = randi() % 2
		direction = 1
		if randomValue == 0:
			direction = -1
		time_elapsed = 0
	
	animation_tree.set("parameters/move/blend_position", direction)
	
	if direction > 0:
		animation_sprite.flip_h = false
	elif direction < 0:
		animation_sprite.flip_h = true
	
	if direction:
		actor.velocity.x = direction * SPEED
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_accept"):
		print("shoot")
		start_shooting.emit()
		
	actor.move_and_slide()
