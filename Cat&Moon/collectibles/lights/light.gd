class_name Light extends Area2D

@onready var animatedsprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.turn_off()

func turn_off():
	animatedsprite.play("off")

func turn_on():
	animatedsprite.play("on")
