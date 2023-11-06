extends Node2D

class_name ShootComponent

signal is_attack_used(attack_used: bool)

@export var cd_time: float = 1.0
@export var attack_name: String
@export var use_state: State

@onready var arrow = preload("res://projectiles/arrow.tscn")
@onready var timer: Timer = $Timer

var can_use_attack: bool = true

func _ready():
	timer.wait_time = cd_time
	timer.connect("_on_timeout", _on_timer_timeout)
	use_state.connect("use_attack", _on_ground_use_attack)

func _on_ground_use_attack(used_attack_name: String):
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
	var shooting_angle = get_parent().shooting_angle
	var new_arrow = arrow.instantiate()
	new_arrow.angle = shooting_angle
	add_child(new_arrow)
	new_arrow = new_arrow.duplicate()
	new_arrow.global_position = self.position

func _on_timer_timeout():
	can_use_attack = true
