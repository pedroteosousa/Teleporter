extends KinematicBody2D

var scenePath = "res://scenes/balls/"
var current_ball = null

# joystick multiplier for speed
var joystick_speed = 300

var gravity = Vector2(0, 100)
var velocity = Vector2(0, 0)

# should camera follow the ball
var should_follow = false

# erase ball from scene
func delete_ball():
	if current_ball:
		if current_ball.get_ref():
			var ball = current_ball.get_ref()
			ball.collision_layer = 0
			ball.collision_mask = 0
			ball.queue_free()
		current_ball = null

# create a new ball checking which ball should be release from parent (level)
func create_ball(dir):
	var ball_name = get_parent().get_current_ball()
	if ball_name == null:
		return
	delete_ball()
	current_ball = weakref(load(scenePath + ball_name + ".tscn").instance())
	current_ball.get_ref().set_position(get_position())
	current_ball.get_ref().go(dir, velocity)
	get_parent().add_child(current_ball.get_ref())

# teleport and warn level
func teleport():
	if current_ball and current_ball.get_ref():
		var ball = current_ball.get_ref()
		var ball_name = ball.get_path().get_name(ball.get_path().get_name_count()-1)
		ball.act(self)
		delete_ball()
		
		# warning level of teleportation
		print(ball_name)
		get_parent().used(ball_name)

func _unhandled_input(event):
	# release ball with mouse
	if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
		create_ball(get_local_mouse_position())
	# release ball with joystick
	if InputMap.event_is_action(event, "release_joystick") and event.is_pressed() and !event.is_echo():
		var direction = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX), Input.get_joy_axis(0, JOY_ANALOG_LY))
		create_ball(direction*joystick_speed)
	
	# teleport to ball location
	if InputMap.event_is_action(event, "teleport") and event.is_pressed():
		teleport()
	
	# jump
	if InputMap.event_is_action(event, "jump") and is_on_floor():
		velocity.y -= 150
	
	# make camera follow the current ball
	if InputMap.event_is_action(event, "follow_ball"):
		if event.is_pressed() and current_ball:
			should_follow = true
		else:
			should_follow = false
			follow_ball()

# update camera location
func follow_ball(pos = Vector2(0, 0), zoom = Vector2(1, 1), smoothing = false):
	get_node("Camera2D").zoom = zoom
	get_node("Camera2D").position = pos
	get_node("Camera2D").smoothing_enabled = smoothing
	
func enemy_collision():
	queue_free()

func _physics_process(delta):
	# gravity
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# update camera behaviour
	if should_follow and current_ball and current_ball.get_ref():
		var screen_size = get_viewport_rect().size
		var dist = current_ball.get_ref().get_position() - get_position()
		var zoom = max(1.0, max(2*abs(dist.x / screen_size.x), 2*abs(dist.y / screen_size.y)))
		follow_ball(dist/2.0, Vector2(zoom, zoom), true)
	elif should_follow:
		should_follow = false
		follow_ball()

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