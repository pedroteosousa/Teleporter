extends "res://scripts/levels/simple_level.gd"

var enemies = []
func utility(id, enter):
	if (enter):
		for i in range (6):
			if (enemies[i] != null and enemies[i].get_ref() != null):
				enemies[i].get_ref().queue_free()
	else:
		for i in range (6):
			if (enemies[i] == null or enemies[i].get_ref() == null):
				enemies[i] = weakref(load("res://scenes/enemies/Fire.tscn").instance())
				enemies[i].get_ref().set_position(32.0*Vector2(32+i, -40))
				add_child(enemies[i].get_ref())

func _ready():
	balls = [["StickyBall", 1], ["SimpleBall", 1], ["BalloonBall", 1]]
	enemies = [null, null, null, null, null, null]
