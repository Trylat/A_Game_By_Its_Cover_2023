class_name Player
extends CharacterBody2D

@export var speed = 300.0
@export var jumpForce = 400.0

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hissArea: Area2D = $HissArea2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var spawnPoint: LampPost = null

func _process(_delta: float) -> void:
	do_animation()
	do_hiss()

func _physics_process(delta: float):
	do_movement(delta)


# @brief Apply user inputs to CharacterBody3D for movement.
# @param delta The delta time in seconds
func do_movement(delta: float):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("player_jump_up") and is_on_floor():
		velocity.y = -jumpForce

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_walk_left", "player_walk_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


# @brief Select current animation based on CharacterBody3D.
func do_animation():
	# face left or right
	if velocity.x > 0:
		animatedSprite.flip_h = false
	elif velocity.x < 0:
		animatedSprite.flip_h = true
	
	# Select animation
	if not is_on_floor():
		animatedSprite.play("jump") # Jumping / Falling
	elif velocity.x != 0:
		animatedSprite.play("walk")
	else:
		animatedSprite.play("idle")

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
