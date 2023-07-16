extends State

@export var air_state : State
@export var iddle_state : State
@export var running_state : State
@export var jump_state : State
@export var state_machine : StateMachine

var is_running = false
var is_walking = true
var direction : Vector2 = Vector2.ZERO

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
	if character.direction.x != direction.x:
		is_walking = false
	if direction.x:
		if Input.is_action_pressed("player_run"):
			is_running = true
	else:
		is_walking = false


func on_enter():
	if state_machine.previous_state != jump_state:
		direction.x = character.direction.x
	else:
		direction.x = state_machine.previous_direction.x


func on_exit():
	is_running = false 
	is_walking = true
	direction = Vector2.ZERO
