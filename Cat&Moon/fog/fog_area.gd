class_name FogArea extends Area2D

signal hiss_received

func _ready():
	$EvilCloudWisperSXF.play()

func on_hiss():
	hiss_received.emit()
	$EvilCloudWisperSXF.stop()
	$CloudDamageFromCatSFX.play()
	$EvilCloudWisperSXF.play()
