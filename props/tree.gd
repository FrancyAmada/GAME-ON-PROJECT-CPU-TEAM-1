extends interactable_object

var x_mark = preload("res://props/extra/x_mark.tscn")

func _ready():
	set_process(true)
	coins_needed = 1

func _pass_coin():
	call_deferred("on_pass_coin")
	last_coin_pass_time = 0

func _process(delta):
	var coins = 0
	for child in get_children():
		if child.is_in_group("coin"):
			coins += 1
			coins_in = coins
	if coins >= coins_needed:
		mark_to_cut()
		
	last_coin_pass_time += delta
	if last_coin_pass_time >= delay_before_drop:
		await get_tree().create_timer(.6).timeout
		drop_all_coins()

func on_pass_coin():
	var new_coin = Coin.instantiate()
	add_child(new_coin)
	new_coin.global_position = Game.player_position + Vector2(0, -25)
	new_coin.set_gravity_scale(0)
	var tween = get_tree().create_tween()
	tween.tween_property(new_coin, "position", position - self.position + Vector2(0, -35), .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func drop_all_coins():
	for child in get_children():
		if child.is_in_group("coin"):
			var coin = child
			coin.set_gravity_scale(1)

func show_coins_need():
	var coin_holder_initial = coinHolder.instantiate()
	add_child(coin_holder_initial)
	coin_holder_initial.show_coins_required(coins_needed)

func close_coins_need():
	for child in get_children():
		if child.is_in_group("coin holder"):
			child.queue_free()

func mark_to_cut():
	var x = x_mark.instantiate()
	add_child(x)
	for child in get_children():
		if child.is_in_group("coin"):
			child.queue_free()
