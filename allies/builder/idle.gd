class_name builder_idle_state
extends NodeState_builder

signal start_building

@export var actor : builder
@onready var animation_tree : AnimationTree = $"../../AnimationTree"
@onready var animation_sprite : Sprite2D = $"../../Sprite2D"
var SPEED : int
var time_elapsed = 0
var direction = 0

var run_away: bool = false


func _ready():
	SPEED = actor.SPEED
	animation_tree.active = true

func _enter_state():
	animation_tree["parameters/conditions/dies"] = false
	animation_tree["parameters/conditions/stop_building"] = true
	animation_tree["parameters/conditions/build"] = false
	set_physics_process(true)

func _exit_state():
	animation_tree["parameters/conditions/dies"] = true
	animation_tree["parameters/conditions/stop_building"] = false
	animation_tree["parameters/conditions/build"] = false
	set_physics_process(false)

func _physics_process(delta):
	if !actor.building_to_construct and !actor.building and !actor.is_dead:
		check_enemy_distance()
		
		if not run_away:
			time_elapsed += delta
		
			if time_elapsed >= 2:
				var randomValue = randi() % 2
				direction = 1
				if randomValue == 0:
					direction = -1
				time_elapsed = 0
		else:
			time_elapsed = 0
#			print_debug("direction ", str(direction))
			
		animation_tree.set("parameters/walk/blend_position", direction)
	else:
		direction = 0
	
	if direction > 0:
		animation_sprite.flip_h = false
	elif direction < 0:
		animation_sprite.flip_h = true
	
	actor.velocity.x = direction * SPEED
	
	actor.move_and_slide()

func check_enemy_distance():
	var enemy = actor.enemy
	if enemy != null:
		var enemy_distance = actor.enemy_distance
		if enemy_distance < 200:
			direction = -sign(enemy.global_position.x - actor.global_position.x)
			run_away = true
		else:
			direction = 0
			run_away = false
