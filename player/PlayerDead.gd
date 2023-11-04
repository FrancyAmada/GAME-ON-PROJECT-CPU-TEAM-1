extends State

class_name PlayerDeadState

@export var dead_animation_node: String = "Death"


func on_enter():
	playback.travel(dead_animation_node)
