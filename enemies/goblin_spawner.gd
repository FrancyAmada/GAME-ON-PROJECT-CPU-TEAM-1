extends Node2D

@export var goblin: PackedScene
@export var initial_spawn_interval: float
@onready var enemy_timer = $EnemyTimer

func _ready():
	update_spawn_interval()

func _on_enemy_timer_timeout():
	if !DayNight.is_day:
		var new_goblin = goblin.instance()
		add_child(new_goblin)
		new_goblin.global_position = global_position

		# Update the spawn interval after spawning an enemy
		update_spawn_interval()

func update_spawn_interval():
	enemy_timer.wait_time = calculate_spawn_interval(DayNight.day_count)

func calculate_spawn_interval(day_count: int) -> float:
	# You can adjust the base and multiplier values based on your desired rate of decrease
	var base = 2.0
	var multiplier = 0.2
	
	# Calculate the logarithmic decrease
	var new_spawn_interval = initial_spawn_interval / (base ** (day_count * multiplier))
	
	return new_spawn_interval
