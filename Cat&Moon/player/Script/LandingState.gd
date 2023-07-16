extends State

@export var state_machine : StateMachine
@export var walk_state : State
@export var run_state : State
@export var idle_state : State

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "JumpEnd":
		if state_machine.previous_state == run_state || state_machine.previous_state == walk_state:
			next_state = state_machine.previous_state
		else:
			next_state = idle_state

func on_exit():
	print("Previous State: ", state_machine.previous_state.name)
	print("Next State: ", next_state.name)

