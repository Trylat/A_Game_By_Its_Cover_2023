extends Node

class_name StateMachine 

@export var initial_state : State
@export var character : CharacterBody2D
@export var animation_tree : AnimationTree

var current_state : State
var states : Dictionary = {}


func _ready():
	# List States that are StateMachine childrens
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			
			#Setup Child to be usefull
			child.character = character
			child.playback = animation_tree["parameters/playback"]
		
		else:
			push_warning("Child " + child.name + " is not a State!!")
			
	if initial_state:
		initial_state.on_enter()
		current_state = initial_state


# Handle the player input to feed it to the current State
func _input(event : InputEvent):
	current_state.state_input(event)


# Process that need to append on a fix time interval
func _physics_process(delta):
	if(current_state.next_state != null):
		switch_state(current_state.next_state)
	
	current_state.state_process(delta)


# Check if the player can move in the current state
func checkCanMove():
	return current_state.can_move


func switch_state(new_state : State):
	# Execute the last bit of code and clear the old next state so it doesn't stick to a later call
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
		
	current_state = new_state
	
	current_state.on_enter()
