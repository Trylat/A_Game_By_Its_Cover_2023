class_name MovingFog extends Path2D

@export var speed: float = 1

@onready var pathFollow: PathFollow2D = $PathFollow2D

var direction: int = 1

func _ready():
	$PathFollow2D/FogArea/AnimatedSprite2D.play("default")
	$PathFollow2D/AudioStreamPlayer2D.play()

func _physics_process(delta):
	self.pathFollow.progress_ratio += self.speed * delta * self.direction

func reverse_direction():
	self.direction *= -1

func _on_fog_area_hiss_received():
	reverse_direction()

