extends Area2D

class_name Campfire

var animated_sprite : AnimatedSprite2D

func _ready():
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("default")
