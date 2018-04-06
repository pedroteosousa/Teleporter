extends KinematicBody2D

var balls = ["res://scenes/SimpleBall.tscn", "res://scenes/CrazyBall.tscn"]
var current_ball = null

var joystick_speed = 300

var gravity = Vector2(0, 100)
var velocity = Vector2(0, 0)

func delete_ball():
	if current_ball:
		if current_ball.get_ref():
			var ball = current_ball.get_ref()
			ball.collision_layer = 0
			ball.collision_mask = 0
			ball.queue_free()
		current_ball = null
	
func create_ball(index, dir):
	current_ball = weakref(load(balls[index]).instance())
	current_ball.get_ref().set_position(get_position())
	current_ball.get_ref().go(dir)
	get_parent().add_child(current_ball.get_ref())

func _unhandled_input(event):
	if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
		delete_ball()
		create_ball(0, get_local_mouse_position())
	if InputMap.event_is_action(event, "teleport") and event.is_pressed() and current_ball:
		if current_ball.get_ref():
			set_position(current_ball.get_ref().get_position())
		velocity = Vector2(0, 0)
		delete_ball()
	if InputMap.event_is_action(event, "release_joystick") and event.is_pressed() and !event.is_echo():
		delete_ball()
		var direction = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX), Input.get_joy_axis(0, JOY_ANALOG_LY))
		create_ball(0, direction*joystick_speed)
		print(direction)

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