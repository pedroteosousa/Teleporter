# Stores, saves and loads game Settings in an ini-style file
extends Node

const SAVE_PATH = "res://config.cfg"

var _config_file = ConfigFile.new()
var _settings = {
	"audio": { 
		"mute": ProjectSettings.get("settings/mute")
	},
	"window": {
		"width": ProjectSettings.get("display/window/size/width"),
		"height": ProjectSettings.get("display/window/size/height")
	}
}

func _ready():
	#save_settings()
	load_settings()

func save_settings():
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key])
			
	_config_file.save(SAVE_PATH)
	
func load_settings():
	var error = _config_file.load(SAVE_PATH)
	if error != OK:
		print("tu tomaste no chucrute!")
	
	for section in _settings.keys():
			for key in _settings[section]:
				set_setting(section, key, _config_file.get_value(section, key))

func get_setting(category, key):
	return _settings[category][key]


func set_setting(category, key, value):
	_settings[category][key] = value