extends Node

class_name CharacterStateMachine

@export var character: CharacterBody2D
@export var animation_component: AnimationComponent
@export var current_state: State
@export var death_anim_name: String = "Death"

@onready var animation_tree: AnimationTree = animation_component.animation_tree

var states: Array[State]


func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			
			# Setup the states
			child.character = character
			child.playback = animation_tree["parameters/playback"]
			
			# Connect to interrupt signal
			child.connect("interrupt_state", on_state_interrupt_state)
			
		else:
			push_warning("Child " + child.name + " is not a State for the StateMachine")
			
	animation_component.connect("animation_is_finished", _on_animation_tree_animation_finished)
	
func _physics_process(delta):
	if current_state.next_state != null:
		switch_states(current_state.next_state)
	
func check_if_can_move():
	return current_state.can_move

func switch_states(new_state: State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
		
	current_state = new_state
	current_state.on_enter()
	
func _input(event: InputEvent):
	current_state.state_input(event)

func on_state_interrupt_state(new_state: State):
	switch_states(new_state)

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == death_anim_name:
		if get_parent().name == "Player":
			pass
		else:
			get_parent().queue_free()

func _on_health_component_on_death(dead_state):
	switch_states(dead_state)
