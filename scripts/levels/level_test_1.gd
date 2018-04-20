extends "res://scripts/levels/simple_level.gd"


#var wall = load("res://scenes/walls/SimpleWall.tscn").instance()
#wall.set_position(32.0*Vector2(17.0, 0.0))
#add_child(wall)

func utility(id, enter):
	if (enter):
		print("Oi" + id)