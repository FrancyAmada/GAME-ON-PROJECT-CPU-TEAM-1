extends Node2D

@onready var timer: Timer = $Timer

@export var goblin: PackedScene
@export var spawn_interval: float = 20.0

func _ready():
	pass
		
func _on_enemy_timer_timeout():
	if !DayNight.is_day:
		var new_goblin = goblin.instantiate()
		add_child(new_goblin)
		new_goblin.global_position = global_position
