extends AttackComponent

@export var damage: float = 10.0
@export var attack_area: Area2D
@export var knockback_distance: float = 100.0
@export var detection_collision_component: AttackCollisionComponent 

@onready var enemy_detector: AttackDetectionComponent = $EnemyDetector
@onready var enemy_detected: bool = false
@onready var character: CharacterBody2D = get_parent()

var direction: float = 0
var enemy: CharacterBody2D

func _ready():
	timer.wait_time = cd_time
	timer.connect("_on_timeout", _on_timer_timeout)
	animation_component.connect("facing_direction_changed", _on_facing_direction_changed)
	use_state.connect("use_attack", _on_attack_use)
	enemy_detector.connect("is_enemy_detected", _on_enemy_is_detected)

func _on_attack_1_body_entered(body):
	if body is builder:
		attack_builder(body)
		return 0
		
	for child in body.get_children():
		if child is HitBoxComponent:
			# get direction from the sword to the body
			var direction_to_damageable = body.global_position - get_parent().global_position
			direction = sign(direction_to_damageable.x)
			do_melee_attack(child, direction)
			print_debug(body.name + " took " + str(damage) + " damage.")
			
func _on_attack_1_area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.get_parent().is_in_group("wall"):
		body.get_parent().damage()

func do_melee_attack(hit_box: HitBoxComponent, direction: float):
	var knockback = Vector2(knockback_distance * direction, -200)
	hit_box.receive_hit(damage, knockback)

func attack_builder(body: CharacterBody2D):
	body.take_hit(damage)

func _on_facing_direction_changed(facing_right: bool):
	if facing_right:
		attack_collision_component.position = attack_collision_component.facing_right_position
		detection_collision_component.position = detection_collision_component.facing_right_position
	else:
		attack_collision_component.position = attack_collision_component.facing_left_position
		detection_collision_component.position = detection_collision_component.facing_left_position

func check_if_enemy_is_detected():
	return enemy_detected

func _on_enemy_is_detected(detected: bool):
	enemy_detected = detected

