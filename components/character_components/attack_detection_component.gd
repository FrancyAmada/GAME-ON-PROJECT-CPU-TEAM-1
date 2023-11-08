extends Area2D

class_name AttackDetectionComponent

signal use_attack(attack_name: String)

signal is_enemy_detected(detected: bool)

@export var attack_component: AttackComponent

@onready var attack_name: String = attack_component.attack_name

var enemies_list: Array
var enemy_detected: bool = false


func _physics_process(delta):
	if len(enemies_list) == 0:
		enemy_detected = false
	
	if enemy_detected and attack_component.check_if_can_use():
		for enemy in enemies_list:
			if enemy is Player:
				var health_component = enemy.find_child("HealthComponent")
				if health_component.health > 0:
					emit_signal("use_attack", attack_name)
				else:
					enemies_list.erase(enemy)
			else:
				emit_signal("use_attack", attack_name)
	emit_signal("is_enemy_detected", enemy_detected)
		
func _on_body_entered(body):
	for child in body.get_children():
		if child is HitBoxComponent:
			enemies_list.append(body)
			enemy_detected = true

func _on_body_exited(body):
	for enemy in enemies_list:
		if body == enemy:
			enemies_list.erase(body)
	if len(enemies_list) == 0:
		enemy_detected = false

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print_debug(body)
	if body.get_parent().is_in_group("wall"):
		enemy_detected = true
		enemies_list.append(body)
		print_debug("a wall is detected")
