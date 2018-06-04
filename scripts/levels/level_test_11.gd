extends "res://scripts/levels/simple_level.gd"

var destroyed = 0
var WALLS_AMOUNT = 8
var wall = []

func init():
	balls = [["SimpleBall", 5], ["BowlingBall", 1]]

func utility(id, enter):
	if (enter):
		destroy_walls()

func destroy_walls():
	if (!destroyed):
		for i in range (WALLS_AMOUNT):
			wall[i].queue_free()
		destroyed = 1

func _ready():
	for i in range (WALLS_AMOUNT):
		wall.append(null)
		
	for i in range (WALLS_AMOUNT):
		wall[i] = load("res://scenes/walls/SimpleWall.tscn").instance()
		wall[i].set_position(32.0*Vector2(20.5, -12+i))
		add_child(wall[i])
	