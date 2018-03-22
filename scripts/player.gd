extends RigidBody2D

var balls = ["res://scenes/simple_ball.xml"]
var current_ball = null

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON and !event.pressed and event.button_index == 1:
		print("soltando")
		if current_ball:
			current_ball.queue_free()
		current_ball = load(balls[0]).instance()
		current_ball.set_linear_velocity(get_linear_velocity())
		current_ball.go(get_local_mouse_pos())
		add_child(current_ball)
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed and event.button_index == 2 and current_ball:
		# perguntar para o will
		pass

func _process(delta):
	if (Input.is_action_pressed("click") and current_ball):
		set_pos(current_ball.get_pos() + get_pos())
		set_linear_velocity(Vector2(0, 0))
		current_ball.queue_free()
		current_ball = null

func _ready():
	set_process(true)
	set_process_input(true)