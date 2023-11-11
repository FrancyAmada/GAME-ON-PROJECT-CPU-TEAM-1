extends Node2D

class_name CoinDetectionComponent

signal chase_coin(body: RigidBody2D)

@onready var detection_area: Area2D = $CoinDetection
@onready var character: CharacterBody2D = get_parent()

var coin_list: Array

var target_coin: RigidBody2D
var coin_distance: int

func _ready():
	Signals.connect("coin_collected", _on_coin_collected_signal)
	detection_area.connect("_on_body_entered", _on_coin_detection_body_entered)
	detection_area.connect("_on_body_exited", _on_coin_detection_body_exited) 

func _physics_process(delta):
	coin_distance = 600
	target_coin = null
	var distance: int
	
	for coin in coin_list:
		distance = abs(character.global_position.x - coin.global_position.x)
		if distance < coin_distance:
			coin_distance = distance
			target_coin = coin
		
	if len(coin_list) != 0:
		start_chase(target_coin)
	else:
		coin_distance = 600
		target_coin = null
		stop_chase()
	
func start_chase(body: RigidBody2D):
	emit_signal("chase_coin", body)
	
func stop_chase():
	emit_signal("chase_coin", null)

func _on_coin_detection_body_entered(body):
	if body.is_in_group("coin"):
		coin_list.append(body)
	
func _on_coin_detection_body_exited(body):
	if body in coin_list:
		coin_list.erase(body)
		
	if len(coin_list) == 0:
		stop_chase()
		coin_distance = 600

func _on_coin_collected_signal(coin: Node):
	if coin in coin_list:
		coin_list.erase(coin)

func get_coin():
	if len(coin_list) == 0:
		target_coin = null
		coin_distance = 600
	else:
		target_coin = coin_list[0]
	return [target_coin, coin_distance]
