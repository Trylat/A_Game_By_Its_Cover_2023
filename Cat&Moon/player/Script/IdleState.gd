extends State

@export var air_state : State
@export var walking_state : State
@export var running_state : State
@export var high_jump_state : State

var is_walking = false
var is_running = false

func state_process(_delta):
	if !character.is_on_floor():
		next_state = air_state
	if is_running:
		next_state = running_state
	elif is_walking:
		next_state = walking_state
	else:
		idle()


func state_input(event : InputEvent):
	if event.is_action_pressed("player_jump"):
		jump()


func idle():
	# Look for input that are already pressed
	if abs(character.velocity.x) > 0.1:
		is_walking = true
		if Input.is_action_pressed("player_run"):
			is_running = true


func jump():
	playback.travel("JumpStart")


func on_enter():
	character.velocity = Vector2.ZERO


func on_exit():
	is_walking = false
	is_running = false
	


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "NewJumpStart":
		character.do_v_speed_calculation()
		next_state = high_jump_state
