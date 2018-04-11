extends "res://scripts/walls/simple_wall.gd"

# destroy when collided
func collided_with(object, collision, should_destroy = false):
	if should_destroy:
		queue_free()