extends "res://scripts/balls/simple_ball.gd"

var isStationary = false
onready var area = get_node('Area2D')

# stop on first collision
func collided(collision):
	# make ball go inside the collided object a bit, to make sure area detects intersection
	position -= collision.normal
	
	set_physics_process(false)
	velocity = Vector2(0,0)
	gravity_velocity = Vector2(0,0)
	
	# setting area to identify collisions
	isStationary = true
	
# making own movement to ignore reflect
func movement(delta):
	var collision = move_and_collide(get_movement_pattern()*delta)
	if collision:
		collided(collision)

func _process(delta):
	if isStationary:
		var num_collisions = len(area.get_overlapping_bodies()) + len(area.get_overlapping_areas())
		if num_collisions == 0:
			set_physics_process(true)
			
			# setting area to not identify collisions
			isStationary = false