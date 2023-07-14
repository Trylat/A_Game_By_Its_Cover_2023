class_name LampPost extends Area2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	play_animation_fogged()

func play_animation_on():
	animatedSprite.play("on")

func play_animation_shiny():
	animatedSprite.play("shiny")

func play_animation_fogged():
	animatedSprite.play("fogged")
