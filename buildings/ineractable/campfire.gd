extends Area2D

class_name Campfire

var animated_sprite : AnimatedSprite2D
@onready var audio_stream_player = $AudioStreamPlayer

func _ready():
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("default")

func _on_area_2d_body_entered(body):
	print(body)
	if body.name == "Player":
		audio_stream_player.play()

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		audio_stream_player.stop()
