extends State

@export var landding_state : State

func state_process(delta):
	if abs(character.velocity.y) < 1:
		next_state = landding_state

func on_exit():
	if next_state == landding_state:
		playback.travel("JumpEnd")
