extends RigidBody2D

@onready var bow = $"."

func _ready():
	contact_monitor = true

func _on_body_entered(body):
	if body.name == "jobless":
		Signals.emit_signal("tool_collected", bow)
		body.change_role("archer")
		queue_free()
