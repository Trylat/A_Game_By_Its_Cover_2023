extends State

@export var state_machine : StateMachine
@export var idlestate : State

func state_process(_delta):
	if abs(character.velocity.y) < 1:
		next_state = state_machine.previous_state
