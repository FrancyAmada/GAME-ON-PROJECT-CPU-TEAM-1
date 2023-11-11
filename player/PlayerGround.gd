extends State

class_name PlayerGroundState

signal use_attack(attack_name: String)

signal reset_attack_monitoring

@export var melee_attack: AttackComponent
@export var attack_state: State
@export var attack_node: String = "Attack1"


func _ready():
	melee_attack.connect("is_attack_used", _on_melee_attack_used)

func state_input(event: InputEvent): pass
#	if event.is_action_pressed("attack1"):
#		emit_signal("use_attack", "Melee")	

func _on_melee_attack_used(is_attack_used: bool):
	if is_attack_used:
		attack()

func attack():
	next_state = attack_state
	playback.travel(attack_node)

func on_enter():
	emit_signal("reset_attack_monitoring")
