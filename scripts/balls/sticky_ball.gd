extends "res://scripts/balls/simple_ball.gd"

# stop on first collision
func collided(collision):
	set_physics_process(false)
	velocity = Vector2(0,0)
	gravity_velocity = Vector2(0,0)
	
func _process(delta):
	var area = get_node('Area2D')
	var num_collisions = len(area.get_overlapping_bodies()) + len(area.get_overlapping_areas())
	print(num_collisions)
	if (num_collisions == 0):
		set_physics_process(true)
	else:
		collided(null)