extends RigidBody2D

var speed = 400:wq

func limit_velocity(dir):
	if dir.length() > speed:
		dir = dir.normalized()*speed
	return dir

func go(dir):
	set_linear_velocity(get_linear_velocity() + limit_velocity(dir))

func _ready():
	pass