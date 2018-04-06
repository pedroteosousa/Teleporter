extends VBoxContainer

func _gui_input(event):
	print(event)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_children()[0].grab_focus()
	for i in get_children():
		i.connect("pressed", self, "on_pressed", [i])

func on_pressed(button_name):
	name = button_name.get_name()
	if name == "New game":
		print("click on New game")
		get_tree().change_scene("res://scenes/Universe.tscn")
	elif name == "Continue":
		print("click on Continue")
	elif name == "Options":
		print("click on Options")
		get_tree().change_scene("res://scenes/SettingsMenu.tscn")
	elif name == "Exit":
		print("click on Exit")
		get_tree().quit()