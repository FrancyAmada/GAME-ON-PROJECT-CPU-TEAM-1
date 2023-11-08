extends Node2D

class_name EnemyDetectionComponent

signal chase_enemy(body: CharacterBody2D)

@export var detection_area: Area2D

@onready var character: CharacterBody2D = get_parent()

var enemy_list: Array

var target_enemy: CharacterBody2D
var enemy_distance: int

func _ready():
	Signals.connect("character_died", _on_character_died_signal)
	detection_area.connect("_on_body_entered", _on_enemy_detection_body_entered)
	detection_area.connect("_on_body_exited", _on_enemy_detection_body_exited) 

func _physics_process(delta):
	enemy_distance = 600
	var distance: int
	if target_enemy:
		var health_component: HealthComponent = target_enemy.find_child("HealthComponent")
		if health_component.health <= 0:
			enemy_list.erase(target_enemy)
			target_enemy = null
	
	for enemy in enemy_list:
			
		distance = abs(character.global_position.x - enemy.global_position.x)
		if distance < enemy_distance:
			enemy_distance = distance
			target_enemy = enemy
		
	if len(enemy_list) != 0:
		start_chase(target_enemy)
	else:
		enemy_distance = 600
		target_enemy = null
		stop_chase()
#	print_debug(enemy_list)
	
func start_chase(body: CharacterBody2D):
	emit_signal("chase_enemy", body)
	
func stop_chase():
	emit_signal("chase_enemy", null)

func _on_enemy_detection_body_entered(body):
	var health_component: HealthComponent = body.find_child("HealthComponent")
	var hitbox_component: HitBoxComponent = body.find_child("HitBoxComponent")
	if health_component and hitbox_component:
		if health_component.health > 0:
			enemy_list.append(body)
			
func _on_enemy_detection_body_exited(body):
	if body in enemy_list:
		enemy_list.erase(body)
		
	if len(enemy_list) == 0:
		stop_chase()
		enemy_distance = 600

func _on_character_died_signal(character: Node):
	if character in enemy_list:
		enemy_list.erase(character)

func get_enemy():
	if len(enemy_list) == 0:
		target_enemy = null
		enemy_distance = 600
	else:
		target_enemy = enemy_list[0]
	return [target_enemy, enemy_distance]
