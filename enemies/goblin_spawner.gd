extends Node2D

@onready var timer: Timer = $Timer

@export var goblin: PackedScene
@export var spawn_interval: float = 8.0

func _ready():
	timer.wait_time = spawn_interval
	timer.start()

func _on_timer_timeout():
	var new_goblin = goblin.instantiate()
	
	add_child(new_goblin)
	new_goblin.global_position = global_position
	
