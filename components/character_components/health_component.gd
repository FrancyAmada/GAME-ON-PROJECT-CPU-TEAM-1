extends Node2D

class_name HealthComponent

signal health_changed(node: Node, health_change: float)

signal on_death(node: Node)

@export var max_health: float = 100.0:
	get:
		return health
	set(value):
		health = value

var health: float = max_health:
	get:
		return health
	set(value):
		emit_signal("health_changed", get_parent(), value - health)
		health = value

func _on_health_changed(node, health_change):
	if health_change > 0:
		if health > max_health:
			health = max_health
	else:
		if health <= 0:
			emit_signal("on_death", node)
