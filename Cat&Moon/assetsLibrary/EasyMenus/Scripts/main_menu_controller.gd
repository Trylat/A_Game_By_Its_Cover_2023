class_name MainMenuController extends Control
signal new_game_pressed
signal load_game_pressed

@onready var new_game_button: Button = $Content/NewGameButton
@onready var load_game_button: Button = $Content/LoadGameButton
@onready var options_menu: OptionsMenuController = $%OptionsMenu
@onready var content: Control = $%Content 

func _ready():
	new_game_button.grab_focus()

func quit():
	get_tree().quit()
	
func open_options():
	options_menu.show()
	content.hide()
	options_menu.on_open()
	
func close_options():
	content.show();
	new_game_button.grab_focus()
	options_menu.hide()

func open_main_menu():
	self.show()

func close_main_menu():
	self.hide()

func disable_load_game_button():
	load_game_button.disabled = true

func enable_load_game_button():
	load_game_button.disabled = false

func _on_load_game_button_pressed():
	emit_signal("load_game_pressed")

func _on_new_game_button_pressed():
	emit_signal("new_game_pressed")
