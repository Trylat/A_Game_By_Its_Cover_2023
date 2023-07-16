class_name FogArea extends Area2D

signal hiss_received

func on_hiss():
	hiss_received.emit()
