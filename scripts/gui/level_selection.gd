extends Control

var level_button = load("res://scenes/gui/LevelButton.tscn")
var buttons = []
onready var vbox = get_node("VBoxContainer")

func _ready():
	pass

func init():
	var grid_size = int((len(get_parent().levels)+2)/3)
	var index = 0
	while index < len(get_parent().levels):
		var button = level_button.instance()
		buttons.append(button)
		var child = int(index / grid_size)
		vbox.get_child(child).add_child(button)
		button.init(index+1)
		button.get_node("MarginContainer/Button").connect("pressed", self, "on_pressed", [index])
		index += 1

func on_pressed(index):
	get_parent().start_level(index)

func update():
	var index = 0
	var enabled = true
	while index < len(get_parent().levels):
		var button = buttons[index]
		button.is_enabled(enabled)
		enabled = get_parent().levels[index].completed
		index += 1