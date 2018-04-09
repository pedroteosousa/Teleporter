extends "res://scripts/balls/simple_ball.gd"

func collided(collision):
	queue_free()

func get_amplitude():
	return min(2*speed, speed*elapsed_time)

func get_movement_pattern():
	var new_velocity = velocity + velocity.rotated(PI/2.0).normalized() * cos(elapsed_time*10)*get_amplitude()
	return new_velocity