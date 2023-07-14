extends Node
class_name State

signal  Transitioned

@export var can_move : bool = true

var character : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var next_state : State

#This is what process is run in the state at all time when this is the current state
func state_process(delta):
	pass

#Actions that are performed when we enter the state
func on_enter():
	pass

#Action that are performed just before we exit the state
func on_exit():
	pass

#Function that deal with player input within the state
func state_input(event : InputEvent):
	pass
