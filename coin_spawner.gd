extends Node2D

var Coin = preload("res://collectables/coin.tscn")

func _ready():
	Signals.connect("drop_coin", _drop_coin)
	Signals.connect("remove_coin", _drop_coin)
	Signals.connect("generate_coin", _on_generate_coin)

func _on_timer_timeout():
	var new_coin_temp = Coin.instantiate()
	add_child(new_coin_temp)
	new_coin_temp.global_position = Vector2(200, 50)

func _drop_coin():
	call_deferred("on_drop_coin")

func on_drop_coin():
	var new_coin = Coin.instantiate()
	add_child(new_coin)
	var velocity_x = randi_range(-140, 140)
	var newVelocity = Vector2(velocity_x, -130)
	new_coin.set_linear_velocity(newVelocity)
	new_coin.global_position = Game.player_position + Vector2(0, -35)

func _on_generate_coin(node: Node, amount: int):
	for x in range(amount):
		var new_coin = Coin.instantiate()
		add_child(new_coin)
		var velocity_x = randi_range(-140, 140)
		var newVelocity = Vector2(velocity_x, -60)
		new_coin.set_linear_velocity(newVelocity)
		new_coin.global_position = node.global_position
