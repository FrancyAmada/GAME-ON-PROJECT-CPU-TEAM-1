extends Area2D

var Coin = preload("res://collectables/coin.tscn")

func _ready():
	Signals.connect("pass_coin", _pass_coin)

func _pass_coin():
	call_deferred("on_pass_coin")

func _process(delta):
	var coins = 0
	for child in get_children():
		if child.is_in_group("coin"):
			coins += 1
	if coins >= 2:
		await get_tree().create_timer(.6).timeout
		self.queue_free()

func on_pass_coin():
	var new_coin = Coin.instantiate()
	add_child(new_coin)
	new_coin.global_position = Game.player_position + Vector2(0, -25)
	new_coin.set_gravity_scale(0)
	var tween = get_tree().create_tween()
	tween.tween_property(new_coin, "position", position - self.position + Vector2(0, -35), .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
