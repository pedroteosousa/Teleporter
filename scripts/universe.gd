extends Node

var basePath = "res://scenes/"

onready var save = get_node('/root/save')

var levels = [
{'name': 'TutorialLevel1', 'time': INF, 'completed': false},
{'name': 'TutorialLevel2', 'time': INF, 'completed': false},
{'name': 'TutorialLevel3', 'time': INF, 'completed': false},
{'name': 'TutorialLevel4', 'time': INF, 'completed': false}
]

var cur_level = 0

func init():
	save.save_game()
	print("LEN" + str(len(levels)))
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

func restart_level():
	var tmp = get_node("CurrentLevel")
	remove_child(tmp)
	tmp.queue_free()
	init()

func completed_level(elapsed_time):
	levels[cur_level].completed = true
	levels[cur_level].time = min(elapsed_time, levels[cur_level].time)
	save.save_game()
	if cur_level+1 < len(levels):
		cur_level += 1
		restart_level()

func _ready():
	save.load_game()
	init()

func save():
	return {'levels': levels}