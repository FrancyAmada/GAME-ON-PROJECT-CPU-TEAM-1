extends Node2D

var animated_sprite : AnimatedSprite2D

func _ready():
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("default")
