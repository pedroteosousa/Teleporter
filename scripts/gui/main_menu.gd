extends VBoxContainer

onready var music = get_node("/root/Music")

var elapsed_time = 0
var new_balloon_time = 1

onready var save = get_node('/root/save')

var scenePath = "res://scenes/"
var ball_queue = []

func _ready():
	get_tree().paused = false
	music.play()
	get_children()[0].get_children()[1].grab_focus()
	for i in get_children():
		i.get_children()[0].visible = false
		var button = i.get_children()[1]
		button.connect("pressed", self, "on_pressed", [button])

func _process(delta):
	for i in get_children():
		var button = i.get_children()[1]
		if button.is_hovered():
			button.grab_focus()
		i.get_children()[0].visible = button.has_focus()

func on_pressed(button):
	var name = button.get_name()
	if name == "New game":
		print("click on New game")
		save.save_game()
		get_tree().change_scene("res://scenes/Universe.tscn")
		music.stop()
	elif name == "Continue":
		print("click on Continue")
		get_tree().change_scene("res://scenes/Universe.tscn")
		music.stop()
	elif name == "Options":
		print("click on Options")
		get_tree().change_scene("res://scenes/gui/SettingsMenu.tscn")
	elif name == "Exit":
		print("click on Exit")
		get_tree().quit()