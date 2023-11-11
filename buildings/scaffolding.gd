extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	set_progress(1)

func set_progress(progress):
	if progress <= 5:
		var animation_name = str(progress)
		animated_sprite_2d.play(animation_name)
