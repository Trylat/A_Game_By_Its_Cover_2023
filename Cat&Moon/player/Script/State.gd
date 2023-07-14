extends Node
class_name State

signal  Transitioned

@export var can_move : bool = true

#Actions that are performed when we enter the state
func on_enter():
	pass

#Action that are performed just before we exit the state
func on_exit():
	pass

