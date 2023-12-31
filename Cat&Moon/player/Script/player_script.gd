class_name Player
extends CharacterBody2D
signal OnNewSpawnPoint


@onready var Sprite: Sprite2D = $Sprite2D
@onready var hissArea: Area2D = $HissArea2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine := $StateMachine as StateMachine

@export var h_speed_max : float = 200.0
@export var h_step_speed : float = 1.0

@export var v_speed_init : float = 400
@export var v_speed_min : float = 200

@export var spawnPoint: LampPost = null
@export var nbLightsCollected: int = 0

@export var deadSounds: Array[AudioStream]
@onready var deadAudioPlayer := $DeadAudioStreamPlayer2D as AudioStreamPlayer2D
@onready var hissSfx := $HissArea2D/HissSFX as AudioStreamPlayer

var levelCompleted := false
var isImmortal := false
var isAlive: bool = true
var angularVelocity: float = 0.0
var drag := 0.80

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var playback : AnimationNodeStateMachinePlayback
var is_running = false 
var last_dir = 0.0
var vel_scale = Vector2.ZERO
var is_alive = true

func _ready():
	animation_tree.active = true


func _process(_delta):
	do_animation()
	

func _physics_process(delta):
	if (isAlive):
		h_speed_max = state_machine.current_state.h_speed_max
		process_inputs(delta)
		do_sprite_flip()
		do_hiss()
		do_animation()
	else:
		do_drag()
	
	do_gravity(delta)
	self.rotate(angularVelocity) 
	move_and_slide()

func do_drag():
	self.velocity.x *= drag
	angularVelocity *= drag
	
	if abs(velocity.x) < 10:
		velocity.x = 0 
	
	if abs(angularVelocity) < 0.01:
		angularVelocity = 0 

func do_gravity(delta : float):
	if not is_on_floor():
		velocity.y += gravity * delta

func process_inputs(delta: float):
	# Get character movement direction vector based on player input
	var direction = FixedInput.get_vector("player_walk_left", "player_walk_right", "player_look_up", "player_look_down")

	if (sign(direction.x) == sign(velocity.x)) || \
	   (velocity.x == 0) && \
	   state_machine.checkCanMove():
		do_h_speed_calculation(direction)
	else:
		do_drag()

func do_h_speed_calculation(direction):
	velocity.x += direction.x * abs(h_step_speed * state_machine.vector_modifier.x)
	velocity.x = clamp(velocity.x, -h_speed_max, h_speed_max)
	
	

func do_v_speed_calculation():
	var x = clamp((abs(velocity.x) / 300), 0.0, 1.0)
	var v_speed = -velocity.x  * (velocity.x/v_speed_init) + v_speed_init
	v_speed = clamp(v_speed, v_speed_min, v_speed_init) 
	velocity.y = - v_speed


func do_sprite_flip():
	# face sprite left or right
	if velocity.x > 0:
		Sprite.flip_h = false
		Sprite.rotation = 0
	elif velocity.x < 0:
		Sprite.flip_h = true


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
	animation_tree.set("parameters/Move/4/blend_position", -1 if Sprite.flip_h else 1)
	animation_tree.set("parameters/Move/5/blend_position", vel_scale.x)
	animation_tree.set("parameters/Move/6/blend_position", vel_scale.x)

# @brief Manage inputs for hiss and do actions accordingly.
func do_hiss():
	if(not Input.is_action_just_pressed("player_hiss")):
		return
	hissSfx.play()
	var isNewSpawnPointFounded: bool = false
	for area in hissArea.get_overlapping_areas():
		if (area is LampPost):
			# Old spawn point
			if (spawnPoint != null):
				spawnPoint.play_animation_on() 
			
			# Newly founded spawn point
			spawnPoint = area as LampPost
			isNewSpawnPointFounded = true

		elif (area is FogArea):
			var fogArea: FogArea = area as FogArea
			fogArea.on_hiss()

	if (isNewSpawnPointFounded):
		spawnPoint.play_animation_shiny();
		SignalBus.OnNewSpawnPoint.emit()

func _on_pickup_area_2d_area_entered(area: Area2D):
	if (area is MoonFragment):
		if (!levelCompleted):
			isImmortal = true
			levelCompleted = true
			SignalBus.OnMoonFragmentCollected.emit()
	elif (area is Light):
		var light = area as Light
		if (not light.is_on()):
			light.turn_on()
			nbLightsCollected += 1
			StaticFog.on_light_collected(nbLightsCollected)

func kill() -> void:
	if (isAlive && !isImmortal):
		isAlive = false
		angularVelocity = 0.001 * velocity.x
		drag = 0.98
		state_machine.switch_state(state_machine.states["dead"])
		
		var cam = $Camera2D as Camera2D
		var camPosition = cam.global_position
		self.remove_child(cam)
		self.get_parent().add_child(cam)
		cam.global_position = camPosition
		
		deadAudioPlayer.stream = deadSounds.pick_random()
		deadAudioPlayer.play()
		
		SignalBus.onPlayerDeath.emit()

func _on_hit_area_2d_area_entered(area:Area2D):
	if area is FogArea:
		self.kill()

