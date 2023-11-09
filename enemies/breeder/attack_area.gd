extends Area2D

@export var ground_state: State


# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = false
	ground_state.connect("reset_attack_monitoring", _on_attack_reset)

func _on_attack_reset():
	monitoring = false
