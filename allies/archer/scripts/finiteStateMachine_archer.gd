class_name finiteStateMachine_archer

extends Node

@export var state: NodeState_archer

func _ready():
	changeState(state)

func changeState(new_state : NodeState_archer):
	if state is NodeState_archer:
		state._exit_state()
	new_state._enter_state()
	state = new_state
