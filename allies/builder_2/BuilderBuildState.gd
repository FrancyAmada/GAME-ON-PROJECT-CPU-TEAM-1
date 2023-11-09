extends State

class_name BuilderBuildState

signal stop_building

@export var animation_component: AnimationComponent
@export var ground_state: State
@export var build_anim_name: String = "Build"
@export var return_anim_name: String = "Move"


func _ready():
	animation_component.connect("animation_is_finished", _on_animation_is_finished)
#	get_parent().character.connect("stop_building", )

func on_enter():
	set_physics_process(true)
	
func on_exit():
	set_physics_process(false)

func _physics_process(delta):
	if !character.building_to_construct:
		next_state = ground_state
		playback.travel(return_anim_name)

func _on_animation_is_finished(anim_name: String):
	if anim_name == build_anim_name and character.building and character.building_to_construct:
		character.building = false
		character.building_to_construct.add_construction_points()
		await get_tree().create_timer(.2).timeout
		stop_building.emit()
