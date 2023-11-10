extends RigidBody2D

@onready var coin = $"."

func _ready():
	contact_monitor = true

func _on_body_entered(body):
	if body.name == "Player":
		Signals.emit_signal("add_coin")
		Signals.emit_signal("coin_collected", coin)
		queue_free()
	
	if body.name == "homeless":
		Signals.emit_signal("coin_collected", coin)
		body.sayhi()
