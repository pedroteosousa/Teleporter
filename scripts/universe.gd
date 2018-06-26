extends Node

var basePath = "res://scenes/"

var levels = ["TutorialLevel1", "TutorialLevel1", "TutorialLevel2", "LevelTest13", "LevelTest4", "LevelTest5", "LevelTest6", "LevelTest1"]
var cur_level = 0

func init():
	var level = levels[cur_level]
	level = load(basePath + "levels/" + level + ".tscn").instance()
	level.set_name("CurrentLevel")
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

func restart_level():
	var tmp = get_node("CurrentLevel")
	remove_child(tmp)
	tmp.queue_free()
	init()

func completed_level():
	if cur_level+1 < len(levels):
		cur_level += 1
		restart_level()

func _ready():
	init()