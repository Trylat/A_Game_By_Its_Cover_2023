extends Node2D

@onready var firstLevel = preload("res://level_test/level_test_scene.tscn")
@onready var pauseMenu: PauseMenuController = $CanvasLayer/PauseMenu as PauseMenuController
@onready var mainMenu: MainMenuController = $CanvasLayer/MainMenu as MainMenuController

var currentLevel: Node2D

func _ready():
	pauseMenu.close_pause_menu()

func _process(_delta):
	if (currentLevel != null):
		if (Input.is_action_just_pressed("game_pause")):
			pauseMenu.open_pause_menu()

func _on_main_menu_start_game_pressed():
	mainMenu.close_main_menu()
	# Load the first level
	currentLevel = firstLevel.instantiate()
	add_child(currentLevel)

func _on_pause_menu_back_to_main_pressed():
	currentLevel.queue_free()
	mainMenu.open_main_menu()
