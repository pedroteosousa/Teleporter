extends "res://scripts/levels/simple_level.gd"

var walls = []
func utility(id, enter):
	if (enter):
		for i in range (3):
			if (walls[i] != null and walls[i].get_ref() != null):
				walls[i].get_ref().queue_free()
	else:
		for i in range (3):
			if (walls[i] == null or walls[i].get_ref() == null):
				walls[i] = weakref(load("res://scenes/walls/SimpleWall.tscn").instance())
				walls[i].get_ref().set_position(32.0*Vector2(19.5, -6.5+i))
				add_child(walls[i].get_ref())

func _ready():
	balls = [["SimpleBall", 1], ["DreddBall", 1]]
	walls = [null, null, null]