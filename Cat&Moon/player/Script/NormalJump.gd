extends State

@export var landding_state : State

func state_process(delta):
	if character.is_on_floor():
		next_state = landding_state

func on_enter():
	character.velocity.y = state_v_speed
	character.move_and_slide()

func on_exit():
	if next_state == landding_state:
		playback.travel("JumpEnd")
