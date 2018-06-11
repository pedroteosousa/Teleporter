extends "res://scripts/levels/simple_level.gd"

var destroyed = 0
var WALLS_AMOUNT = 6
var wall = []

func init():
	balls = [["SimpleBall", 2], ["StickyBall", 2], ["DreddBall", 1]]

func utility(id, enter):
	if (enter):
		destroy_walls()

func destroy_walls():
	if (!destroyed):
		for i in range (4):
			wall[i].queue_free()
		for i in range (2):
			wall[i] = load("res://scenes/walls/SimpleWall.tscn").instance()
			wall[i].set_position(32.0*Vector2(20.5, 3.5+i))
			add_child(wall[i])
		destroyed = 1

func _ready():
	for i in range (WALLS_AMOUNT):
		wall.append(null)
		
	for i in range (2):
		wall[i] = load("res://scenes/walls/SimpleWall.tscn").instance()
		wall[i].set_position(32.0*Vector2(21.5+i, 5.5))
		add_child(wall[i])
	
	for i in range (2):
		wall[2+i] = load("res://scenes/walls/SimpleWall.tscn").instance()
		wall[2+i].set_position(32.0*Vector2(21.5+i, 2.5))
		add_child(wall[2+i])
		
	