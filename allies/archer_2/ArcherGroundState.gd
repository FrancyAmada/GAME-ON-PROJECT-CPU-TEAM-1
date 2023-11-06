extends State

class_name ArcherGroundState

signal use_attack(attack_name: String)

@export var shoot_attack: ShootComponent
@export var attack_state: State
@export var shoot_anim_name: String = "Shoot"

func _ready():
	shoot_attack.connect("is_attack_used", _on_shoot_attack_used)
	get_parent().connect("use_attack", _on_shoot_attack_use)
	
func _on_shoot_attack_use(attack_name: String):
	emit_signal("use_attack", "Shoot")

func _on_shoot_attack_used(is_attack_used: bool):
	if is_attack_used:
		attack()

func attack():
	next_state = attack_state
	playback.travel(shoot_anim_name)
