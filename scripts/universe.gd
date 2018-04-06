extends Node

var basePath = "res://scenes/"

func _input(event):
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if InputMap.event_is_action(event, "pause") and event.is_pressed() and !event.is_echo():
		get_tree().paused = !get_tree().paused

func _ready():
	var map = get_node("LevelLayout")
	var level = get_node("Level")
	var tileset = map.tile_set
	for cell in map.get_used_cells():
		var tile = map.get_cell(cell.x, cell.y)
		var name = tileset.tile_get_name(tile)
		var path = basePath + name + ".tscn"
		var pos = cell * map.cell_size.x
		var object = load(path).instance()
		object.set_position(pos)
		level.add_child(object)
	map.hide()
	
	set_process_input(true)
	set_process(true)