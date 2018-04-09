extends KinematicBody2D

var basePath = "res://scenes/balls/"
var balls = ["SimpleBall", "CrazyBall", "StickyBall", "DreddBall"]
var current_ball = null
var current_ball_index = 0

var joystick_speed = 300

var gravity = Vector2(0, 100)
var velocity = Vector2(0, 0)

var should_follow = false

func delete_ball():
	if current_ball:
		if current_ball.get_ref():
			var ball = current_ball.get_ref()
			ball.collision_layer = 0
			ball.collision_mask = 0
			ball.queue_free()
		current_ball = null
	
func create_ball(index, dir):
	current_ball = weakref(load(basePath + balls[index] + ".tscn").instance())
	current_ball.get_ref().set_position(get_position())
	current_ball.get_ref().go(dir, velocity)
	get_parent().add_child(current_ball.get_ref())

func update_current_ball():
	var ball = load(basePath + balls[current_ball_index] + ".tscn").instance()
	var ball_sprite = ball.get_node('Sprite')
	get_node("HUD/VBoxContainer/Sprite").texture = ball_sprite.texture
	get_node("HUD/VBoxContainer/Sprite").scale = ball_sprite.scale
	get_node("HUD/VBoxContainer/Current Ball").text = ball.ball_name

func _unhandled_input(event):
	if InputMap.event_is_action(event, "change_current_ball_down") and event.is_pressed():
		current_ball_index = (current_ball_index-1+len(balls))%len(balls)
		update_current_ball()
	if InputMap.event_is_action(event, "change_current_ball_up") and event.is_pressed():
		current_ball_index = (current_ball_index+1)%len(balls)
		update_current_ball()
	if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
		delete_ball()
		create_ball(current_ball_index, get_local_mouse_position())
	if InputMap.event_is_action(event, "teleport") and event.is_pressed() and current_ball:
		if current_ball.get_ref():
			set_position(current_ball.get_ref().get_position())
		velocity = Vector2(0, 0)
		delete_ball()
	if InputMap.event_is_action(event, "release_joystick") and event.is_pressed() and !event.is_echo():
		delete_ball()
		var direction = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX), Input.get_joy_axis(0, JOY_ANALOG_LY))
		create_ball(current_ball_index, direction*joystick_speed)
	if InputMap.event_is_action(event, "follow_ball"):
		if event.is_pressed() and current_ball:
			should_follow = true
		else:
			should_follow = false
			follow_ball()

func follow_ball(pos = Vector2(0, 0), zoom = Vector2(1, 1), smoothing = false):
	get_node("Camera2D").zoom = zoom
	get_node("Camera2D").position = pos
	get_node("Camera2D").smoothing_enabled = smoothing

func _physics_process(delta):
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if should_follow and current_ball and current_ball.get_ref():
		var screen_size = get_viewport_rect().size
		var dist = current_ball.get_ref().get_position() - get_position()
		var zoom = max(1.0, max(2*abs(dist.x / screen_size.x), 2*abs(dist.y / screen_size.y)))
		follow_ball(dist/2.0, Vector2(zoom, zoom), true)
	elif should_follow:
		should_follow = false
		follow_ball()

func _ready():
	update_current_ball()
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