class_name LampPost extends Area2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

enum AnimationEnum {
	FOGGED,
	ON,
	SHINY
}

const animationNames: Dictionary = {
	AnimationEnum.FOGGED: "fogged",
	AnimationEnum.ON: "on",
	AnimationEnum.SHINY: "shiny"
}

@export var currentAnimation: AnimationEnum = AnimationEnum.FOGGED


func _ready():
	play_animation(currentAnimation)

func play_animation_on():
	play_animation(AnimationEnum.ON)

func play_animation_shiny():
	play_animation(AnimationEnum.SHINY)

func play_animation_fogged():
	play_animation(AnimationEnum.FOGGED)

func play_animation(animation: AnimationEnum):
	currentAnimation = animation
	animatedSprite.play(animationNames[currentAnimation])
