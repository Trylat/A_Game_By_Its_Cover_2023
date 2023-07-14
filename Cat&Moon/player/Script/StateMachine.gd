extends Node

class_name StateMachine 

@export var initial_state : State
@export var character : CharacterBody2D

var current_state : State
var states : Dictionary = {}

func _ready():
	# List States that are StateMachine childrens
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			
			#Setup Child to be usefull
			
		else:
			push_warning("Child " + child.name + " is not a State!!")
			
	if initial_state:
		initial_state.on_enter()
		current_state = initial_state

# Check if the player can move in the current state
func checkCanMove():
	return current_state.can_move
