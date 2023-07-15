class_name MoonFragment extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Play random variant animation.
	var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
	var animations: PackedStringArray = animatedSprite.sprite_frames.get_animation_names()
	animatedSprite.play(animations[randi_range(0, len(animations) - 1)])
