extends State

class_name BreederGroundState

signal use_attack(attack_name: String)

signal reset_attack_monitoring

@export var melee_attack1: AttackComponent
@export var attack1_detector: AttackDetectionComponent
@export var attack_state: State
@export var attack1_node: String = "Attack"


func _ready():
	melee_attack1.connect("is_attack_used", _on_melee_attack_used)
	attack1_detector.connect("use_attack", _on_attack1_use)
	
func _on_attack1_use(attack_name: String):
	emit_signal("use_attack", attack1_node)

func _on_melee_attack_used(is_attack_used: bool):
	if is_attack_used:
		attack()

func attack():
	next_state = attack_state
	playback.travel(attack1_node)

func on_enter():
	emit_signal("reset_attack_monitoring")
	
