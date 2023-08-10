extends State

@export var air_state : State
@export var iddle_state : State
@export var running_state : State
@export var jump_state : State
@export var state_machine : StateMachine

var is_running = false
var is_walking = true

func state_process(_delta):
	if !character.is_on_floor():
		next_state = air_state
	elif is_running:
		next_state = running_state
	elif !is_walking:
		next_state = iddle_state
	else:
		walk()


func state_input(event : InputEvent):
	if event.is_action_pressed("player_jump"):
		jump()


func jump():
	character.do_v_speed_calculation()
	next_state = jump_state


func walk():
	# Get character movement direction vector based on player input
	if abs(character.velocity.x) > 0.1:
		is_walking = true
		if Input.is_action_pressed("player_run"):
			is_running = true
	else:
		is_walking = false
		is_running = false

func on_exit():
	is_running = false 
	is_walking = true
