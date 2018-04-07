extends KinematicBody2D

export (int) var speed = 500
export (float) var bounce = 1
export (float) var gravity = 100

var velocity = Vector2(0, 0)
var gravity_velocity = Vector2(0, 0)
var elapsed_time = 0.0

func limit_velocity(dir):
	if dir.length() > speed:
		dir = dir.normalized()*speed
	return dir

func go(dir):
	velocity = limit_velocity(dir)

func get_movement_pattern():
	return velocity

func collided():
	pass

func _physics_process(delta):
	elapsed_time += delta
	velocity.y += gravity * delta
	var collision = move_and_collide(get_movement_pattern()*delta)
	if collision:
		collided()
		velocity = velocity.bounce(collision.normal)*bounce

func _ready():
	set_physics_process(true)