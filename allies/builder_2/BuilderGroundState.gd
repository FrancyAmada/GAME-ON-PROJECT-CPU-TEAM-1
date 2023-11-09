extends State

class_name BuilderGroundState

@export var build_state: State
@export var build_anim_name: String = "Build"



func _ready():
	get_parent().character.connect("start_building", _on_start_building)
	
func _on_start_building():
	next_state = build_state
	playback.travel(build_anim_name)

