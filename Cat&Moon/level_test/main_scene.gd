extends Node2D

@export var levels: Array[PackedScene]

@onready var pauseMenu := $CanvasLayer/PauseMenu as PauseMenuController
@onready var mainMenu := $CanvasLayer/MainMenu as MainMenuController
@onready var levelCompletedMenu := $CanvasLayer/LevelCompletedMenu as Control
@onready var victoryMenu := $CanvasLayer/VictoryMenu as VictoryMenuController

const savePath: String = "user://Save/"

const persistentDatasSavePath = savePath + "persistenDatas.tres"
var persistentDatas: PersistentDatas = PersistentDatas.new()

const currentLevelSavePath = savePath + "currentLevel.tscn"
var currentLevel: Node2D = null

func _ready() -> void:
	SignalBus.OnNewSpawnPoint.connect(save_game)
	SignalBus.OnMoonFragmentCollected.connect(_on_moon_fragment_collected)
	SignalBus.onPlayerDeath.connect(_on_player_death)
	pauseMenu.close_pause_menu()
	levelCompletedMenu.hide()
	victoryMenu.close_menu()
	get_tree().auto_accept_quit = false
	get_tree().quit_on_go_back = false
	if (not DirAccess.dir_exists_absolute(savePath)):
		DirAccess.make_dir_recursive_absolute(savePath)
	if (is_game_saved()):
		mainMenu.enable_load_game_button()
	else: 
		mainMenu.disable_load_game_button()

func _process(_delta) -> void:
	if (currentLevel != null):
		if (Input.is_action_just_pressed("game_pause")):
			pauseMenu.open_pause_menu()

'''
@brief Save the game into the user space.
'''
func save_game() -> void:
	var error: Error = OK
	var currentLevelPacked: PackedScene = PackedScene.new()
	
	if (error == OK): error = currentLevelPacked.pack(currentLevel)
	if (error == OK): error = ResourceSaver.save(currentLevelPacked, currentLevelSavePath)
	if (error == OK): error = ResourceSaver.save(persistentDatas, persistentDatasSavePath)
	if (error != OK): push_error("An error occurred while saving the game.")

'''
@brief Check if game saved in the user space.
'''
func is_game_saved() -> bool:
	return ResourceLoader.exists(currentLevelSavePath) && ResourceLoader.exists(persistentDatasSavePath)

'''
@brief Load the game progression from the user space and start the game.
'''
func start_load_game() -> void:
	if not is_game_saved():
		push_error("Can't load unsaved game!")
		return
	
	if currentLevel != null: currentLevel.queue_free()
	
	persistentDatas = ResourceLoader.load(persistentDatasSavePath, "Resource", ResourceLoader.CACHE_MODE_IGNORE)
	var loadedLevelPacked: PackedScene = ResourceLoader.load(currentLevelSavePath, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE)
	currentLevel = loadedLevelPacked.instantiate()
	add_child(currentLevel)

'''
@brief Start a level by index.
'''
func start_level(levelIndex: int) -> void:
	if levelIndex >= levels.size():
		push_error("Can't start level ", levelIndex, ": out of bound!")
		return
	
	if currentLevel != null: currentLevel.queue_free()
	currentLevel = levels[persistentDatas.currentLevelIndex].instantiate()
	add_child(currentLevel)

'''
@brief Start a new game without erasing saved game.
The saved game will be overwritted during the next save.
'''
func start_new_game() -> void:
	persistentDatas = PersistentDatas.new()
	start_level(persistentDatas.currentLevelIndex)

'''
@brief Start the next level and save the game.
'''
func start_next_level() -> void:
	persistentDatas.currentLevelIndex += 1
	
	if (persistentDatas.currentLevelIndex < levels.size()):
		start_level(persistentDatas.currentLevelIndex)
		save_game()
	elif (persistentDatas.currentLevelIndex == levels.size()):
		victoryMenu.open_menu()
	else:
		push_error("Level ", persistentDatas.currentLevelIndex, " is invalid!")

func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_WM_GO_BACK_REQUEST:
		# Do stuff before quitting the game.
		# For example, saving.
		get_tree().quit()

func _on_main_menu_load_game_pressed() -> void:
	start_load_game()
	mainMenu.close_main_menu()

func _on_main_menu_new_game_pressed() -> void:
	start_new_game()
	mainMenu.close_main_menu()

func _on_victory_menu_back_to_main_pressed():
	back_to_main_menu();

func _on_pause_menu_back_to_main_pressed():
	back_to_main_menu();

func back_to_main_menu():
	currentLevel.queue_free()
	if (is_game_saved()):
		mainMenu.enable_load_game_button()
	else: 
		mainMenu.disable_load_game_button()
	mainMenu.open_main_menu()

func _on_moon_fragment_collected():
	levelCompletedMenu.show()
	await(get_tree().create_timer(5.0).timeout)
	levelCompletedMenu.hide()
	start_next_level()

func _on_player_death():
	await(get_tree().create_timer(5.0).timeout)
	start_load_game()
