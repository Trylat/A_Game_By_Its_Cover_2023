class_name Light extends Area2D


enum AnimationEnum {
	OFF,
	ON
}

const animationNames: Dictionary = {
	AnimationEnum.OFF: "off",
	AnimationEnum.ON: "on"
}

@export var currentAnimation: AnimationEnum = AnimationEnum.OFF
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	play_animation(currentAnimation)

func turn_off():
	play_animation(AnimationEnum.OFF)

func turn_on():
	play_animation(AnimationEnum.ON)

func is_on() -> bool:
	return currentAnimation == AnimationEnum.ON

func play_animation(animation: AnimationEnum):
	currentAnimation = animation
	animatedSprite.play(animationNames[currentAnimation])
		
