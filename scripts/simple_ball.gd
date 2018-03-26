extends KinematicBody2D

var speed = 300
var velocity = Vector2(0, 0)
var bounce = 1.0

func limit_velocity(dir):
	if dir.length() > speed:
		dir = dir.normalized()*speed
	return dir

func go(dir):
	velocity = limit_velocity(dir)

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.bounce(collision.normal)*bounce
		
func _ready():
	set_physics_process(true)