extends Node

var basePath = "res://scenes/"

onready var save = get_node('/root/save')

var levels = [
{'name': 'TutorialLevel1', 'time': null, 'completed': true},
{'name': 'LevelTest2', 'time': null, 'completed': true},
{'name': 'LevelTest5', 'time': null, 'completed': true},
{'name': 'TutorialLevel2', 'time': null, 'completed': true},
{'name': 'LevelTest1', 'time': null, 'completed': true},
{'name': 'TutorialLevel3', 'time': null, 'completed': true},
{'name': 'LevelTest14', 'time': null, 'completed': true},
{'name': 'TutorialLevel4', 'time': null, 'completed': true},
{'name': 'LevelTest12', 'time': null, 'completed': true},
{'name': 'LevelTest11', 'time': null, 'completed': true},
{'name': 'LevelTest6', 'time': null, 'completed': true},
{'name': 'LevelTest10', 'time': null, 'completed': true},
{'name': 'LevelTest13', 'time': null, 'completed': true},
]

var cur_level = 0

var level_selection = null

func init():
	level_selection.visible = false
	save.save_game()
	var level = levels[cur_level].name
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

func remove_level():
	var tmp = get_node("CurrentLevel")
	if tmp == null:
		return
	remove_child(tmp)
	tmp.queue_free()

func restart_level():
	remove_level()
	init()

func start_level(level_number):
	cur_level = level_number
	restart_level()

func completed_level(elapsed_time):
	level_selection.visible = true
	levels[cur_level].completed = true
	if levels[cur_level].time == null:
		levels[cur_level].time = elapsed_time
	else:
		levels[cur_level].time = min(elapsed_time, levels[cur_level].time)
	save.save_game()
	level_selection.update()

func _ready():
	save.load_game()
	print(levels)
	level_selection = get_node("Level Selection")
	level_selection.init()
	level_selection.update()
	#init()

func save():
	return {'levels': levels}