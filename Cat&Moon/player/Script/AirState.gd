extends State

@export var state_machine : StateMachine
@export var touchdown_sfx : AudioStreamPlayer

func state_process(_delta):
	if character.is_on_floor():
		touchdown_sfx.play()
		next_state = state_machine.previous_state
		
