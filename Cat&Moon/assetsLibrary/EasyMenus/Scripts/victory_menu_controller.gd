class_name VictoryMenuController extends Control
signal resume
signal back_to_main_pressed

@onready var content : VBoxContainer = $Content
@onready var back_to_menu_button: Button = $Content/BackToMenuButton
	
func open_menu():
	#Stops game and shows pause menu
	show()
	back_to_menu_button.grab_focus()
	
func close_menu():
	hide()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_back_to_menu_button_pressed():
	self.close_menu()
	back_to_main_pressed.emit()

func _input(event: InputEvent):
	if (event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause")) and visible:
		accept_event()
		self.close_menu()
