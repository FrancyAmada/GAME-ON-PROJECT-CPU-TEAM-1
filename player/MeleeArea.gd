extends Area2D


@export var ground_state: State


func _ready():
	monitoring = false
	ground_state.connect("reset_attack_monitoring", _on_attack_monitoring_reset)
	
func _on_attack_monitoring_reset():
	monitoring = false
