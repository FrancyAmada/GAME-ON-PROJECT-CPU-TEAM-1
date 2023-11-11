extends Node2D

class_name EnemySpawner

@export var spawner_id: int = 0
@export var goblin: PackedScene = preload("res://enemies/goblin/goblin.tscn")
@export var breeder: PackedScene = preload("res://enemies/breeder/breeder.tscn")
@export var initial_spawn_interval: float
@onready var enemy_timer = $EnemyTimer
@onready var structure_node = get_parent()
@onready var audio_stream_player = $AudioStreamPlayer

var count: int = 0
var start_spawn_day: int = DayNight.day_count


func _ready():
	update_spawn_interval()

func _on_enemy_timer_timeout():
	if check_if_activated():
		if !DayNight.is_day:
			print_debug("ACTIVATED SPAWNER ID: ", spawner_id)
			var new_goblin = goblin.instantiate()
			add_child(new_goblin)
			new_goblin.global_position = global_position

			# Update the spawn interval after spawning an enemy
			update_spawn_interval()
			if count < 20:
				count += 1
			else:
				count = 0
				var new_breeder = breeder.instantiate()
				add_child(new_breeder)
				new_breeder.global_position = Vector2(global_position.x, global_position.y-70)
				print_debug("Breeder has been spawned.")
				

func update_spawn_interval():
	enemy_timer.wait_time = calculate_spawn_interval(DayNight.day_count)

func calculate_spawn_interval(day_count: int) -> float:
	# You can adjust the base and multiplier values based on your desired rate of decrease
	var base = 2.0
	var multiplier = 0.2
	
	# Calculate the logarithmic decrease
	var new_spawn_interval = initial_spawn_interval / (base ** (day_count * multiplier))
	
	return new_spawn_interval

func _on_remove_area_body_entered(body):
	if DayNight.is_day and body.is_in_group("enemy"):
		body.queue_free()

func check_if_activated():
	if start_spawn_day <= DayNight.day_count:
		for structure in structure_node.get_children():
			if structure is EnemySpawner and structure != self:
				if structure.spawner_id < spawner_id:
					return false
		return true
	else:
		print_debug("cannot spawn today")
		return false

func _on_audio_body_entered(body):
	if body.name == "Player":
		audio_stream_player.play()

func _on_audio_body_exited(body):
	if body.name == "Player":
		audio_stream_player.stop()
