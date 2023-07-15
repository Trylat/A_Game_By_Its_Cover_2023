class_name Player
extends CharacterBody2D


@onready var Sprite: Sprite2D = $Sprite2D
@onready var hissArea: Area2D = $HissArea2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine : StateMachine = $StateMachine

var direction = Vector2.ZERO
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var spawnPoint: LampPost = null

func _ready():
	animation_tree.active = true


func _process(delta):
	do_animation()	
	

func _physics_process(delta):
	do_movement(delta)
	do_hiss()


func do_movement(delta: float):
	# Get character movement direction vector based on player input
	direction = Input.get_vector("player_walk_left", "player_walk_right", "player_look_up", "player_look_down")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if direction && state_machine.checkCanMove():
		velocity.x = direction.x * state_machine.state_h_speed * state_machine.vector_modifier.x
	else:
		velocity.x = move_toward(velocity.x, 0, state_machine.state_h_speed)

	move_and_slide()
	do_animation()



func do_sprite_flip():
	# face sprite left or right
	if direction.x > 0:
		Sprite.flip_h = false
	elif direction.x < 0:
		Sprite.flip_h = true


# @brief Select current animation based on CharacterBody2D
func do_animation():
	do_sprite_flip()
	# Use velocity vector to blend animations whit the animation tree
	animation_tree.set("parameters/Move/blend_position", direction.x) 


# @brief Manage inputs for hiss and do actions accordingly.
func do_hiss():
	if(not Input.is_action_just_pressed("player_hiss")):
		return

	for area in hissArea.get_overlapping_areas():
		if (area is LampPost):
			# Old spawn point
			if (spawnPoint != null):
				spawnPoint.play_animation_on() 
			
			# Newly founded spawn point
			spawnPoint = area as LampPost
			spawnPoint.play_animation_shiny();
