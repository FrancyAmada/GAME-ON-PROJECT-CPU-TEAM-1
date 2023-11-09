class_name builder_dead_state
extends NodeState_builder

@onready var builder = $"../.." as builder
@onready var animation_tree : AnimationTree = $"../../AnimationTree"
@onready var animation_sprite : Sprite2D = $"../../Sprite2D"

@export var actor : builder

var SPEED : int

# Called when the node enters the scene tree for the first time.
func _ready():
	builder.animation_is_finished.connect(_on_animation_tree_finished)
	SPEED = actor.SPEED
	animation_tree.active = true

func _enter_state():
	animation_tree["parameters/conditions/dies"] = true
	animation_tree["parameters/conditions/stop_building"] = false
	animation_tree["parameters/conditions/build"] = false
	set_physics_process(true)

func _physics_process(delta):
	pass

func _on_animation_tree_finished(anim_name: String):
	if anim_name == "death":
		actor.queue_free()
