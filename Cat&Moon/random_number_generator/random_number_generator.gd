'''
@brief Used to initialize the @Global RandomNumberGenerator.
See the "Random number generation" documentation for more details.
'''

extends Node2D

func _ready():
	randomize()
