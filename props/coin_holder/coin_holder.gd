extends Node2D

class_name coin_holder

func show_coins_required(number):
	if number == 1:
		get_node("AnimatedSprite2D").play("1")
	if number == 2:
		get_node("AnimatedSprite2D").play("2")
	if number == 3:
		get_node("AnimatedSprite2D").play("3")
	if number == 4:
		get_node("AnimatedSprite2D").play("4")
	if number == 5:
		get_node("AnimatedSprite2D").play("5")
	if number == 6:
		get_node("AnimatedSprite2D").play("6")
