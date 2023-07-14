extends State

@export var jump_force = -200.0
@export var air_state : State
@export var jump_animation : String = "JumpStart"


func state_process(delta):
	if !character.is_on_floor():
		next_state = air_state


func state_input(event : InputEvent):
	if(event.is_action_pressed("player_jump")):
		jump()

func jump():
	character.velocity.y = jump_force
	next_state = air_state
	playback.travel(jump_animation)

