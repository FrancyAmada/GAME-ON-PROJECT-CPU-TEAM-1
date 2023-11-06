extends Area2D

@onready var archer = $".." as archer

var enemy = null

func _ready():
	monitoring = true

func _physics_process(delta):
	var distance = 100000
	
	if enemy:
		distance = global_position.distance_to(enemy.global_position)
		
		var direction = (enemy.global_position - global_position)
		
		if direction.x < 0:
			distance *= -1
	
	archer.enemy_distance = distance

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		enemy = body
