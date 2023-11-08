class_name builder_build_state
extends NodeState_builder

signal stop_building

@onready var builder = $"../.." as builder

@export var actor : builder
@onready var animation_tree : AnimationTree = $"../../AnimationTree"
@onready var animation_sprite : Sprite2D = $"../../Sprite2D"
var SPEED : int
var time_elapsed = 0
var direction = 0

func _ready():
	builder.animation_is_finished.connect(_on_animation_tree_finished)
	SPEED = actor.SPEED
	animation_tree.active = true

func _enter_state():
	actor.building = true
	animation_tree["parameters/conditions/dies"] = false
	animation_tree["parameters/conditions/stop_building"] = false
	animation_tree["parameters/conditions/build"] = true
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	pass

func _on_animation_tree_finished(anim_name: String):
	if anim_name == "build":
		print("stop")
		actor.building = false
		actor.building_to_construct.add_construction_points()
		await get_tree().create_timer(.2).timeout
		stop_building.emit()
