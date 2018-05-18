extends KinematicBody2D

export (String) var ball_name = "Test Ball"
export (float) var timeout = -1.0
export (int) var speed = 500
export (float) var bounce = 1
export (float) var gravity = 100

var velocity = Vector2(0, 0)
var gravity_velocity = Vector2(0, 0)
var elapsed_time = 0.0

# store if ball is considered used
var used = false

# ball action
func act(player):
	player.set_position(get_position())
	used = true
	queue_free()

# cap the ball initial velocity
func limit_velocity(dir):
	if dir.length() > speed:
		dir = dir.normalized()*speed
	return dir

# defines the initial velocity of the ball
func go(dir, vel):
	velocity = limit_velocity(dir) + vel

# setting up which process should run
func init():
	set_physics_process(true)

# change velocity in a defined pattern (is called every physics_process)
func get_movement_pattern():
	return velocity

# called when ball collides
func collided(collision):
	pass

# check ball timer
# always return the percentage of time elapsed or -1 if there is no timeout
func check_timeout():
	if timeout < 0:
		return -1
	if elapsed_time >= timeout:
		timeout()
	return elapsed_time / timeout

# called when timeout is over
func timeout():
	queue_free()

# function determining movement
func movement(delta):
	var collision = move_and_collide(get_movement_pattern()*delta)
	if collision:
		var reflect = collision.remainder.bounce(collision.normal)
		velocity = velocity.bounce(collision.normal)
		move_and_collide(reflect)
		#collided(collision)
		#if "velocity" in collision.collider and "bounce" in collision.collider:
		#	print(collision.collider)
		#velocity = velocity.bounce(collision.normal)*bounce
		
func enemy_collision():
	queue_free()

func _physics_process(delta):
	# updating elapsed time
	elapsed_time += delta
	
	check_timeout()
	
	# updating location
	velocity.y += gravity * delta
	movement(delta)

func _ready():
	print(collision_layer)
	init()