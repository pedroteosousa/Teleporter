extends Node

var basePath = "res://scenes/"

func _process(delta):
	if get_tree().paused != get_node("HUD/PauseMenu").visible:
		get_node("HUD/PauseMenu").visible = get_tree().paused

func _input(event):
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if InputMap.event_is_action(event, "pause") and event.is_pressed() and !event.is_echo():
		get_tree().paused = !get_tree().paused

func _ready():
	set_process_input(true)
	set_process(true)