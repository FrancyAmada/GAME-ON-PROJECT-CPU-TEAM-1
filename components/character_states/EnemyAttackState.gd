extends State

class_name EnemyAttackState

@export var animation_component: AnimationComponent
@export var return_state: State
@export var return_animation_node: String = "Move"
@export var attack1_name: String = "Attack1"

func _ready():
	animation_component.connect("animation_is_finished", _on_animation_tree_finished)

func _on_animation_tree_finished(anim_name: String):
	if anim_name == attack1_name:
		next_state = return_state
		playback.travel(return_animation_node)
