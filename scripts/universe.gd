extends Node

var basePath = "res://scenes/"

func _ready():
	var map = get_node("Map")
	var tileset = map.tile_set
	for cell in map.get_used_cells():
		var tile = map.get_cell(cell.x, cell.y)
		var name = tileset.tile_get_name(tile)
		var path = basePath + name + ".tscn"
		var pos = cell*32
		var object = load(path).instance()
		object.set_position(pos)
		add_child(object)
	map.hide()