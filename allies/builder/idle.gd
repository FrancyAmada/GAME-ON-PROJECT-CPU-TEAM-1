class_name builder_idle_state
extends NodeState_builder

signal start_building

@export var actor : builder
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
	animation_tree["parameters/conditions/stop_building"] = true
	animation_tree["parameters/conditions/build"] = false
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	if !actor.building_to_construct and !actor.building:
		time_elapsed += delta
	
		if time_elapsed >= 2:
			var randomValue = randi() % 2
			direction = 1
			if randomValue == 0:
				direction = -1
			time_elapsed = 0
		animation_tree.set("parameters/walk/blend_position", direction)
	else:
		direction = 0
	
	if direction > 0:
		animation_sprite.flip_h = false
	elif direction < 0:
		animation_sprite.flip_h = true
	
	actor.velocity.x = direction * SPEED
	
	actor.move_and_slide()
