extends VBoxContainer

onready var settings = get_node('/root/settings')

func _ready():
	for i in get_children():
		i.connect("pressed", self, "on_pressed", [i])

func on_pressed(button_name):
	name = button_name.get_name()
	if name == "Audio":
		#print("Click on Audio")
		var val = settings.get_setting("audio", "mute")
		print(val)
		if val == true:
			settings.set_setting("audio", "mute", false)
		else:
			settings.set_setting("audio", "mute", true)
	elif name == "Window Size":
		print("Click on Window Size (does nothing yet)")
	elif name == "Back":
		print("Click on Back (saving settings)")
		settings.save_settings()
		get_tree().change_scene("res://scenes/gui/MainMenu.tscn")