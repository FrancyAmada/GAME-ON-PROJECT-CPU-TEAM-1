extends Area2D

@onready var archer = $".." as archer

func _physics_process(delta):
	var enemies = get_overlapping_bodies()
	var number_of_enemies = 0
	var nearest_distance = 100000
	
	for enemy in enemies:
		if enemy.is_in_group("enemy"):
			number_of_enemies += 1
			var distance = global_position.distance_to(enemy.global_position)
			
			if distance < nearest_distance:
				nearest_distance = distance
	
	print(get_overlapping_bodies())
	
	archer.nearest_enemy_distance = nearest_distance
