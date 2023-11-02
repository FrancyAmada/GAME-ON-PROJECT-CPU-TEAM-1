extends StaticBody2D

var CoinScene = preload("res://coin_stored.tscn")

func _ready():
	Signals.connect("add_coin", _on_coin_collected)
	Signals.connect("remove_coin", _remove_coin)
	Signals.connect("pass_coin", _remove_coin)

func _process(delta):
	var coins = 0
	for child in get_children():
		if child.is_in_group("coin_stored"):
			coins += 1
	Game.setGold(coins)

func _on_coin_collected():
	call_deferred("_spawn_coin")

func _spawn_coin():
	var new_coin = CoinScene.instantiate()
	add_child(new_coin)
	new_coin.position = Vector2(0, -50)

func _remove_coin():
	var children = get_children()
	for i in range(children.size() - 1, -1, -1):
		var child = children[i]
		if child.is_in_group("coin_stored"):
			child.queue_free()
			break

func _on_area_2d_body_entered(body):
	if body.is_in_group("coin_stored"):
		Signals.emit_signal("drop_coin")
		body.queue_free()
