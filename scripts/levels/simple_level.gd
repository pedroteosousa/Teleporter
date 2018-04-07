extends Node2D

export (String) var level_name = "Test Level"

var basePath = "res://scenes/"

func _draw():
	var exit = get_node("Exit")
	var polygon = exit.get_node("CollisionPolygon2D").polygon
	for i in range(polygon.size()):
		polygon.set(i, polygon[i] + exit.transform.get_origin())
	draw_colored_polygon(polygon, Color(1,0.6,0.6,0.5))

func _process(delta):
	var exit = get_node("Exit")
	if exit.get_overlapping_bodies().size() != 0:
		completed()

func completed():
	print("level finished")
	queue_free()

func _ready():
	for map in get_children():
		if !(map is TileMap):
			continue
		var tileset = map.tile_set
		for cell in map.get_used_cells():
			var tile = map.get_cell(cell.x, cell.y)
			var name = tileset.tile_get_name(tile)
			var path = basePath + map.get_name() + "/" + name + ".tscn"
			var pos = cell * map.cell_size.x + Vector2(1,1)*(map.cell_size.x/2)
			var object = load(path).instance()
			object.set_position(pos)
			add_child(object)
		map.hide()
	
	set_process(true)