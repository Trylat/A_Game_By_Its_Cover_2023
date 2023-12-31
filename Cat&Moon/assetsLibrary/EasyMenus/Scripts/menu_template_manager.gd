extends Node
const OptionConstants = preload("res://assetsLibrary/EasyMenus/Scripts/options_constants.gd")
const InputMapUpdater = preload("res://assetsLibrary/EasyMenus/Scripts/input_map_updater.gd")

@onready var ControllerEchoInputGenerator = $ControllerEchoInputGenerator
@onready var startup_loader = $StartupLoader

# Called when the node enters the scene tree for the first time.
func _ready():
	InputMapUpdater.new()._ready()
