extends VBoxContainer

onready var music = get_node("/root/Music")

func _ready():
	get_tree().paused = false
	music.play()
	get_children()[0].grab_focus()
	for i in get_children():
		i.connect("pressed", self, "on_pressed", [i])

func on_pressed(button_name):
	name = button_name.get_name()
	if name == "New game":
		print("click on New game")
		get_tree().change_scene("res://scenes/Universe.tscn")
		music.stop()
	elif name == "Continue":
		print("click on Continue")
		music.stop()
	elif name == "Options":
		print("click on Options")
		get_tree().change_scene("res://scenes/gui/SettingsMenu.tscn")
	elif name == "Exit":
		print("click on Exit")
		get_tree().quit()