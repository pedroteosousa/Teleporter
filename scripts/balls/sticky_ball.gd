extends "res://scripts/balls/simple_ball.gd"

# stop on first collision
func collided(collision):
	set_physics_process(false)

func _ready():
	pass