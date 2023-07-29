class_name Player
extends CharacterBody2D


@onready var Sprite: Sprite2D = $Sprite2D
@onready var hissArea: Area2D = $HissArea2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine : StateMachine = $StateMachine

@export var h_speed_max : float = 200.0
@export var h_step_speed : float = 1.0

@export var v_speed_init : float = 400
@export var v_speed_min : float = 200

var direction = Vector2.ZERO
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var playback : AnimationNodeStateMachinePlayback
var spawnPoint: LampPost = null
var nbLightsCollected: int = 0
var is_running = false 
var last_dir = 0.0
var vel_scale = Vector2.ZERO

func _ready():
	animation_tree.active = true


func _process(_delta):
	do_animation()
	

func _physics_process(delta):
	h_speed_max = state_machine.current_state.h_speed_max
	do_movement(delta)
	do_hiss()


func do_movement(delta: float):
	# Get character movement direction vector based on player input
	if Input.get_vector("player_walk_left", "player_walk_right", "player_look_up", "player_look_down"):
		direction = Input.get_vector("player_walk_left", "player_walk_right", "player_look_up", "player_look_down")
	else :
		direction = Vector2.ZERO

	if direction.x && state_machine.checkCanMove():
		do_h_speed_calculation()
	else:
		velocity.x = 0.0 #move_toward(velocity.x, 0, h_speed_max)
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	do_sprite_flip()
	do_animation()
	move_and_slide()
	

func do_h_speed_calculation():
	if abs(velocity.x) < h_speed_max:
		velocity.x += direction.x * abs(h_step_speed * state_machine.vector_modifier.x)


func do_v_speed_calculation():
	var x = clamp((abs(velocity.x) / 300), 0.0, 1.0)
	var v_speed = -velocity.x  * (velocity.x/v_speed_init) + v_speed_init
	v_speed = clamp(v_speed, v_speed_min, v_speed_init) 
	velocity.y = - v_speed


func do_sprite_flip():
	# face sprite left or right
	if direction.x > 0:
		Sprite.flip_h = false
		Sprite.rotation = 0
		last_dir = 1
	elif direction.x < 0:
		Sprite.flip_h = true
		last_dir = -1


# @brief Select current animation based on CharacterBody2D
func do_animation():
	# Use velocity vector to blend animations whit the animation tree
	

	vel_scale.x = velocity.x / h_speed_max
	vel_scale.y = velocity.y / v_speed_init
	if is_running:
		vel_scale.x = vel_scale.x * 2
	else:
		vel_scale.x = vel_scale.x /2

	animation_tree.set("parameters/Move/blend_position", velocity)
	animation_tree.set("parameters/Move/4/blend_position", last_dir)
	animation_tree.set("parameters/Move/5/blend_position", vel_scale.x)
	animation_tree.set("parameters/Move/6/blend_position", vel_scale.x)
	
	

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
		elif (area is FogArea):
			var fogArea: FogArea = area as FogArea
			fogArea.on_hiss()
	$HissArea2D/HissSFX.play()

func _on_pickup_area_2d_area_entered(area: Area2D):
	if (area is MoonFragment):
		print("Finish the level/Moon fragment count++")
	elif (area is Light):
		var light = area as Light
		if (not light.is_on()):
			light.turn_on()
			nbLightsCollected += 1
			StaticFog.on_light_collected(nbLightsCollected)
