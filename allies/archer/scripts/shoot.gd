class_name archer_shoot_state
extends NodeState_archer

signal stop_shooting

@onready var archer = $"../.." as archer

@export var actor : archer
@onready var animation_tree : AnimationTree = $"../../AnimationTree"
@onready var animation_sprite : Sprite2D = $"../../Sprite2D"
var SPEED : int
var time_elapsed = 0
var direction = 0

func _ready():
	archer.animation_is_finished.connect(_on_animation_tree_finished)
	SPEED = actor.SPEED
	animation_tree.active = true

func _enter_state():
	animation_tree["parameters/conditions/dies"] = false
	animation_tree["parameters/conditions/not_shooting"] = false
	animation_tree["parameters/conditions/shoot"] = true
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	pass


func _on_animation_tree_finished(anim_name: String):
	if anim_name == "attack":
		print("stop shooting")
		stop_shooting.emit()
