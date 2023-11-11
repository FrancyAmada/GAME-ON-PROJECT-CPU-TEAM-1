extends RigidBody2D

@onready var hammer = $"."

func _ready():
	contact_monitor = true

func _on_body_entered(body):
	if body.name == "jobless":
		Signals.emit_signal("tool_collected", hammer)
		body.change_role("builder")
		queue_free()
