extends Node
class_name State

signal  Transitioned

@export var can_move : bool = true
@export var can_rotate : bool = true
@export var state_vector_modifier : Vector2 = Vector2(1.0, 1.0)
@export var h_speed_max : float = 200.0

var character : Player
var playback : AnimationNodeStateMachinePlayback
var next_state : State

#This is what process is run in the state at all time when this is the current state
func state_process(_delta):
	pass

#Actions that are performed when we enter the state
func on_enter():
	pass

#Action that are performed just before we exit the state
func on_exit():
	pass

#Function that deal with player input within the state
func state_input(_event : InputEvent):
	pass
