class_name FogArea extends Area2D

signal hiss_received

@onready var evilCloudWisperSFX := $EvilCloudWisperSXF as AudioStreamPlayer2D
@onready var cloudDamageFromCatSFX := $CloudDamageFromCatSFX as AudioStreamPlayer2D

func _ready():
	evilCloudWisperSFX.play()

func on_hiss():
	hiss_received.emit()
	evilCloudWisperSFX.stop()
	cloudDamageFromCatSFX.play()
	evilCloudWisperSFX.play()
