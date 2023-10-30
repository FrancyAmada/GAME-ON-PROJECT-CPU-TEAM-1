extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		Game.player_gold += 1
		queue_free()
