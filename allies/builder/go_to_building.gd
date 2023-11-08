class_name builder_go_to_building_state
extends NodeState_builder

signal start_building

@export var actor : builder
@onready var animation_tree : AnimationTree = $"../../AnimationTree"
@onready var animation_sprite : Sprite2D = $"../../Sprite2D"
var SPEED : int
var time_elapsed = 0
var direction = 0
@onready var builder = $"../.." as builder

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
	
	var direction = 0
	
	if actor.building_to_construct and !actor.building:
		if builder.building_to_construct:
			var distance = builder.building_to_construct.global_position - builder.global_position
			if distance.x > 0:
				direction = 1
			elif distance.x < 0:
				direction = -1
		animation_tree.set("parameters/walk/blend_position", direction)
	else:
		direction = 0
		
	if direction > 0:
		animation_sprite.flip_h = false
	elif direction < 0:
		animation_sprite.flip_h = true
	
	actor.velocity.x = direction * SPEED
	
	if actor.building_in_area and actor.building_to_construct and !actor.building:
#		print("emit!")
		await get_tree().create_timer(.2).timeout
		start_building.emit()
	
	actor.move_and_slide()
