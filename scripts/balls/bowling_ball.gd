extends "res://scripts/balls/simple_ball.gd"

export (float) var bounce_normal = 0.2
export (float) var destroy_velocity = 200

func collided(collision):
	var impact = velocity_of_collision(collision)
	if impact >= destroy_velocity and collision.collider.has_method("collided_with"):
		collision.collider.collided_with(self, collision, true)

func velocity_of_collision(collision):
	var bounced = velocity.bounce(collision.normal)
	var normal = ((bounced-velocity)/2.0)
	return normal.length()

# get rotation speed based on velocity
func get_rotation_speed():
	return 0.2*abs(velocity.x/speed)

func _physics_process(delta):
	# changing rotation speed and direction
	var dir = 1
	if velocity.x < 0:
		dir = -1
	get_node("Sprite").rotation += dir*get_rotation_speed()

func movement(delta):
	# bowling ball behaviour
	var collision = move_and_collide(get_movement_pattern()*delta)
	if collision:
		collided(collision)
		var bounced = velocity.bounce(collision.normal)
		var normal = ((bounced-velocity)/2.0)
		velocity = normal*bounce_normal + (bounced-normal)*bounce