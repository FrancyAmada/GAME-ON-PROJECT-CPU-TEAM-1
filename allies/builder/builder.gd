class_name builder
extends CharacterBody2D

signal animation_is_finished(anim_name: String)

signal start_check_for_building

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_sprite : Sprite2D = $Sprite2D
@onready var finite_state_machine_builder = $finiteStateMachine_builder as finiteStateMachine_builder
@onready var idle = $finiteStateMachine_builder/idle as builder_idle_state
@onready var build = $finiteStateMachine_builder/build as builder_build_state
@onready var go_to_building = $finiteStateMachine_builder/go_to_building
@onready var build_range = $build_range

const SPEED = 50.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var building_to_construct : building_node = null
var building = false
var building_in_area : building_node = null

func _ready():
	animation_tree.active = true
	build.stop_building.connect(finite_state_machine_builder.changeState.bind(idle))
	go_to_building.start_building.connect(finite_state_machine_builder.changeState.bind(build))
	finite_state_machine_builder.changeState.bind(idle)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = 0
	animation_tree.set("parameters/walk/blend_position", direction)
	
	if direction > 0:
		animation_sprite.flip_h = false
	elif direction < 0:
		animation_sprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	if building_to_construct:
		if building_to_construct.done:
			building_to_construct = null
			building_in_area = null
	else:
		find_buildings()

func _on_animation_tree_animation_finished(anim_name):
	emit_signal("animation_is_finished", anim_name)

func find_buildings():
	var buildings_in_construction = Game.buildings_construction
	if buildings_in_construction.size() > 0:
		for child in buildings_in_construction:
#			print(child)
			if !child.has_builder:
				# to ensure that the builder detects the building even when he is in the build area
				build_range.monitoring = false
				child.has_builder = true
				building_to_construct = child
				finite_state_machine_builder.changeState.bind(go_to_building)
				start_check_for_building.emit()
				

func _on_build_range_area_entered(area):
	if building_to_construct:
		if area == building_to_construct.build_range:
			building_in_area = area.parent
			build_range.monitoring = false

