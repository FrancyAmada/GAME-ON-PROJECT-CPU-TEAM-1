extends RigidBody2D

@onready var coin = $"."
@onready var audio_stream_player = $AudioStreamPlayer

func _ready():
	contact_monitor = true

func _on_body_entered(body):
	if body.name == "Player":
		Signals.emit_signal("add_coin")
		Signals.emit_signal("coin_collected", coin)
		queue_free()
	
	if body.name == "homeless":
		Signals.emit_signal("coin_collected", coin)
		body.change_role()
		queue_free()
