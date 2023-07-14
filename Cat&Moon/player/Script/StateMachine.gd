extends Node

class_name StateMachine 

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			
			#Setup Child to be usefull
			
		else:
			push_warning("Child " + child.name + " is not a State!!")
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func checkCanMove():
	return current_state.canMove
