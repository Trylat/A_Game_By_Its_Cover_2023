extends Node
class_name State

signal  Transitioned

@export var can_move : bool = true
@export var state_h_speed : float = 200.0
@export var state_v_speed : float = 200.0
@export var state_vector_modifier : Vector2 = Vector2(1.0, 1.0)

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
