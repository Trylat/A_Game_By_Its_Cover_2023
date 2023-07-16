extends Label

@export var state_machine : StateMachine

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (state_machine.previous_state != null):
		text = "Previous State : " + state_machine.previous_state.name
