extends Node

var basePath = "res://scenes/"

var levels = ["LevelTest2", "LevelTest3", "LevelTest4", "LevelTest5", "LevelTest6"]
var cur_level = 0

func init(level):
	level = load(basePath + "levels/" + level + ".tscn").instance()
	add_child(level)

func _process(delta):
	# handle pause menu visibility
	if get_tree().paused != get_node("HUD/PauseMenu").visible:
		get_node("HUD/PauseMenu").visible = get_tree().paused
		get_node("HUD/PauseMenu/Continue").grab_focus()

func _input(event):
	# hide or show mouse based on input
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# pause the game
	if InputMap.event_is_action(event, "pause") and event.is_pressed() and !event.is_echo():
		get_tree().paused = !get_tree().paused

func completed_level():
	if cur_level+1 < len(levels):
		cur_level += 1
		init(levels[cur_level])

func _ready():
	init(levels[cur_level])