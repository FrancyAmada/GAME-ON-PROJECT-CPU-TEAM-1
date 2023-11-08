extends State

class_name ArcherAttackState

@export var animation_component: AnimationComponent
@export var return_state: State
@export var return_animation_name: String = "Move"
@export var attack_name: String = "Shoot"


func _ready():
	animation_component.connect("animation_is_finished", _on_animation_tree_finished)

func _on_animation_tree_finished(anim_name: String):
	if anim_name == attack_name:
		next_state = return_state
		playback.travel(return_animation_name)
