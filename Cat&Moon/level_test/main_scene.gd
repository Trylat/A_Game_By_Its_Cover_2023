extends Node2D

@onready var firstLevel = preload("res://level_test/level_test_scene.tscn")
@onready var pauseMenu: PauseMenuController = $CanvasLayer/PauseMenu as PauseMenuController
@onready var mainMenu: MainMenuController = $CanvasLayer/MainMenu as MainMenuController

const saveLevelPath: String = "user://save.tscn"
var loadedLevel: PackedScene
var currentLevel: Node2D

func _ready() -> void:
	SignalBus.OnNewSpawnPoint.connect(_on_new_spawn_point)
	pauseMenu.close_pause_menu()
	get_tree().auto_accept_quit = false
	get_tree().quit_on_go_back = false
	load_level()

func _process(_delta) -> void:
	if (currentLevel != null):
		if (Input.is_action_just_pressed("game_pause")):
			pauseMenu.open_pause_menu()

'''
@brief Save the current level into the user space.
'''
func save_current_level() -> void:
	var scene = PackedScene.new()

	# Only `node` and `body` are now packed.
	var result = scene.pack(currentLevel)
	if result == OK:
		var error = ResourceSaver.save(scene, saveLevelPath)
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")

	load_level()

'''
@brief Load the last saved level from the user space.
This didn't start/switch to the loaded level.
'''
func load_level() -> void:
	if ResourceLoader.exists(saveLevelPath):
		loadedLevel = ResourceLoader.load(saveLevelPath, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE)
		mainMenu.enable_load_game_button()
	else:
		loadedLevel = null
		mainMenu.disable_load_game_button()

'''
@brief Start/switch the current level to another level.
@param level	The level to start/switch to.
'''
func start_level(level: PackedScene) -> void:
	mainMenu.close_main_menu()
	if currentLevel != null:
		currentLevel.queue_free()
	currentLevel = level.instantiate()
	add_child(currentLevel)
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_WM_GO_BACK_REQUEST:
		# Do stuff before quitting the game.
		# For example, saving.
		get_tree().quit()

func _on_main_menu_load_game_pressed() -> void:
	start_level(loadedLevel)

func _on_main_menu_new_game_pressed() -> void:
	start_level(firstLevel)

func _on_pause_menu_back_to_main_pressed():
	currentLevel.queue_free()
	mainMenu.open_main_menu()

func _on_new_spawn_point() -> void:
	save_current_level()

