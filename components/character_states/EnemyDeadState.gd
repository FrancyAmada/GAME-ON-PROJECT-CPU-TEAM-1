extends State

class_name EnemyDeadState

@export var dead_animation_name: String = "Death"


func on_enter():
	playback.travel(dead_animation_name)
