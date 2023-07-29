class_name FogArea extends Area2D

signal hiss_received

func _ready():
	$AudioStreamPlayer2D.play()

func on_hiss():
	hiss_received.emit()
