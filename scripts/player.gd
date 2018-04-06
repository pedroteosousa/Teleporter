extends KinematicBody2D

var balls = ["res://scenes/SimpleBall.tscn", "res://scenes/CrazyBall.tscn"]
var current_ball = null

var gravity = Vector2(0, 100)
var velocity = Vector2(0, 0)

func delete_ball():
	if current_ball:
		if current_ball.get_ref():
			current_ball.get_ref().queue_free()
		current_ball = null
	
func create_ball(index):
	current_ball = weakref(load(balls[index]).instance())
	var dir = get_local_mouse_position()
	current_ball.get_ref().set_position(get_position())
	current_ball.get_ref().go(dir)
	get_parent().add_child(current_ball.get_ref())

func _input(event):
	if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
		delete_ball()
		create_ball(0)
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 2 and current_ball:
		if current_ball.get_ref():
			set_position(current_ball.get_ref().get_position())
		velocity = Vector2(0, 0)
		delete_ball()

func _physics_process(delta):
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _ready():
	set_physics_process(true)
	set_process_input(true)

func save():
	var save_dict = {
		pos = {
			x = global_position.x,
			y = global_position.y
		}
	}
	return save_dict