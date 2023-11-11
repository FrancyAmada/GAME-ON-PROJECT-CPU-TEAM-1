extends interactable_object

class_name holy_shrine

@export var shrine_id: int = 0

var building_name = "Holy Shrine"
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var point_light : PointLight2D = $PointLight2D
@onready var structure_node = get_parent()

var level = 1


func _ready():
	set_process(true)
	coins_needed = 6

func _pass_coin():
	call_deferred("on_pass_coin")
	last_coin_pass_time = 0

func _process(delta):
	var coins = 0
	for child in get_children():
		if child.is_in_group("submitted_coin"):
			coins += 1
			coins_in = coins
	if coins >= coins_needed:
		upgrade()
	
	if coins_in > 0:
		last_coin_pass_time += delta
	if last_coin_pass_time >= delay_before_drop:
		await get_tree().create_timer(.6).timeout
		drop_all_coins()
		last_coin_pass_time = 0
	displayAnimation()

func on_pass_coin():
	var new_coin = Coin.instantiate()
	add_child(new_coin)
	new_coin.global_position = Game.player_position + Vector2(0, -25)
	new_coin.set_gravity_scale(0)
	new_coin.add_to_group("submitted_coin")
	new_coin.remove_from_group("coin")
	var tween = get_tree().create_tween()
	tween.tween_property(new_coin, "position", position - self.position + Vector2(0, -55), .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func drop_all_coins():
	for child in get_children():
		if child.is_in_group("submitted_coin"):
			child.remove_from_group("submitted_coin")
			child.add_to_group("coin")
			var coin = child
			coin.set_gravity_scale(1)
	coins_in = 0

func show_coins_need():
	var coin_holder_initial = coinHolder.instantiate()
	add_child(coin_holder_initial)
	coin_holder_initial.show_coins_required(coins_needed)

func close_coins_need():
	for child in get_children():
		if child.is_in_group("coin holder"):
			child.queue_free()
			
func upgrade():
	for child in get_children():
		if child.is_in_group("submitted_coin"):
			child.queue_free()
	
	level += 1
	coins_in = 0
	point_light.set_texture_scale(level * 1.3)
	if level == 6:
		destroy_spawner()
		close_coins_need()
		remove_from_group("interactable")
		
func destroy_spawner():
	for structure in structure_node.get_children():
		if structure is EnemySpawner:
			if structure.spawner_id == shrine_id:
				structure.queue_free()
				print_debug("SUCCESSFULLY DESTROYED SPAWNER : ", structure.spawner_id)

func displayAnimation():
	var animation_name = str(level)
	animated_sprite_2d.play(animation_name)
