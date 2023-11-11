extends Area2D

class_name Campfire

@export var camp_id: int = 0

var animated_sprite : AnimatedSprite2D

func _ready():
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("default")
