extends KinematicBody2D

var balls = ["res://scenes/SimpleBall.tscn"]
var current_ball = null

var gravity = Vector2(0, 100)
var velocity = Vector2(0, 0)

func _input(event):
	print(event)
	if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
		if current_ball:
			current_ball.queue_free()
		current_ball = load(balls[0]).instance()
		var dir = get_local_mouse_position()
		current_ball.go(dir)
		add_child(current_ball)
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 2 and current_ball:
		var teleport_location = current_ball.get_position() + get_position()
		set_position(teleport_location)
		teleport_location = null
		velocity = Vector2(0, 0)
		current_ball.queue_free()
		current_ball = null

func _physics_process(delta):
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _ready():
	set_physics_process(true)
	set_process(true)
	set_process_input(true)