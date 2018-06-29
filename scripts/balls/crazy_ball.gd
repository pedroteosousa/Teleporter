extends "res://scripts/balls/simple_ball.gd"

# destroy on collision
func collided(collision):
	get_parent().reuse("CrazyBall")
	queue_free()

# get current amplitude
func get_amplitude():
	return min(2*speed, speed*elapsed_time)

# return a cosine pattern of movement
func get_movement_pattern():
	var new_velocity = velocity + velocity.rotated(PI/2.0).normalized() * cos(elapsed_time*10)*get_amplitude()
	return new_velocity 