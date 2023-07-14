extends CharacterBody2D

@export var speed = 300.0
@export var jumpForce = 400.0

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_tree.active = true

func _process(delta) -> void:
	do_animation()

func _physics_process(delta):
	do_movement(delta)


# @brief Apply user inputs to CharacterBody3D for movement.
# @param delta The delta time in seconds
func do_movement(delta):
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
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
	# Select animation base on velocity
	animation_tree.set("parameters/Move/blend_position", velocity.x)
