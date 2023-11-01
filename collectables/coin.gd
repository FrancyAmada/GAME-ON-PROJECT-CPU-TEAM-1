extends RigidBody2D

func _ready():
	contact_monitor = true

func _on_body_entered(body):
	if body.name == "Player":
		Signals.emit_signal("spawnCoin")
		queue_free()
