extends AttackComponent

@export var damage: float = 10
@export var attack_area: Area2D
@export var knockback_distance: float = 100

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var knockback_is_hit: int = 0

var current_damage: float

func attack():
	pass

func _on_melee_body_entered(body):
	for child in body.get_children():
		if child is HitBoxComponent:
			# get direction from the sword to the body
			var direction_to_damageable = body.global_position - get_parent().global_position
			var direction_sign = sign(direction_to_damageable.x)
			
			do_melee_attack(child, direction_sign)
			
			print_debug(body.name + " took " + str(current_damage) + " damage.")
		
func do_melee_attack(hit_box: HitBoxComponent, direction: float):
	var knockback = Vector2(knockback_distance * direction, -200)
	current_damage = damage
	knockback_is_hit = rng.randi_range(0, 1)
	if not knockback_is_hit == 1:
		knockback.x *= 0
		current_damage *= 2
	hit_box.receive_hit(current_damage, knockback)
