extends State

@export var state_machine : StateMachine

func state_process(delta):
	if character.is_on_floor():
		next_state = state_machine.previous_state