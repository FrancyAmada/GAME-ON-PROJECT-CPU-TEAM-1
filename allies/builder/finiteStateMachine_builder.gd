class_name finiteStateMachine_builder

extends Node

@export var state: NodeState_builder

func _ready():
	changeState(state)

func changeState(new_state : NodeState_builder):
	if state is NodeState_builder:
		state._exit_state()
	new_state._enter_state()
	state = new_state
