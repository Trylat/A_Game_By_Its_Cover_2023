extends State

@export var air_state : State
@export var iddle_state : State
@export var running_state : State
@export var normal_jump_state : State

var direction = Vector2.ZERO
var is_running = false
var is_walking = true


func state_process(delta):
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
	next_state = normal_jump_state
	playback.travel("JumpStart")


func walk():
	# Get character movement direction vector based on player input
	direction = Input.get_vector("player_walk_left", "player_walk_right", "player_look_up", "player_look_down")
	if direction.x:
		if Input.is_action_pressed("player_run"):
			is_running = true
	else:
		is_walking = false
	



func on_exit():
	is_running = false
	is_walking = true
