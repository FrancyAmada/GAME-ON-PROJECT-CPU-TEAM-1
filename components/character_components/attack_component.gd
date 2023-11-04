extends Node2D

class_name AttackComponent

signal is_attack_used(attack_used: bool)

@export var animation_component: AnimationComponent
@export var attack_collision_component: AttackCollisionComponent
@export var cd_time: float = 1
@export var attack_name: String
@export var use_state: State

@onready var timer: Timer = $Timer

var can_use_attack: bool = true

func _ready():
	timer.wait_time = cd_time
	timer.connect("_on_timeout", _on_timer_timeout)
	animation_component.connect("facing_direction_changed", _on_facing_direction_changed)
	use_state.connect("use_attack", _on_attack_use)

func _on_attack_use(used_attack_name: String):
	if used_attack_name == attack_name:
		if can_use_attack:
			emit_signal("is_attack_used", true)
			can_use_attack = false
			timer.start()
			attack()
			print_debug(get_parent().name + " used " + attack_name + ".")
		else: pass
#			print_debug(attack_name + " attack is on cooldown.")
			
func check_if_can_use():
	return can_use_attack

# blank slate to be able to make new attacks
func attack():
	pass

func _on_timer_timeout():
	can_use_attack = true

func _on_facing_direction_changed(facing_right: bool):
	if facing_right:
		attack_collision_component.position = attack_collision_component.facing_right_position
	else:
		attack_collision_component.position = attack_collision_component.facing_left_position

