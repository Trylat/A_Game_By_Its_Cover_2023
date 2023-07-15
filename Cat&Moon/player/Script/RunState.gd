extends State

@export var jump_force = -200.0
@export var air_state : State
@export var iddle_state : State
@export var walk_state : State
@export var long_jump_state : State

var is_running = true
var is_walking = true

func state_process(delta):
	if !character.is_on_floor():
		next_state = air_state
	elif !is_running && is_walking:
		next_state = walk_state
	elif  !is_walking:
		next_state = iddle_state
	else:
		run(delta)

func state_input(event : InputEvent):
	if event.is_action_pressed("player_jump"):
		jump()

func run(delta):
	# decide fallback state base on input
	if Input.is_action_pressed("player_walk_left") || Input.is_action_pressed("player_walk_right"):
		is_walking = true
		if Input.is_action_pressed("player_run"):
			is_running = true
		else:
			is_running = false
	else:
		is_walking = false

func on_exit():
	is_running = true
	is_walking = true


func jump():
	character.velocity.y = jump_force
	next_state = long_jump_state
	playback.travel("JumpStart")