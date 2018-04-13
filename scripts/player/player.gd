extends KinematicBody2D

var gravity = Vector2(0, 100)
var velocity = Vector2(0, 0)

var current_ball = null

# should camera follow the ball
var should_follow = false

func get_current_ball():
	if len(get_parent().ball_queue):
		current_ball = get_parent().ball_queue[0].obj

func _unhandled_input(event):
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
	get_current_ball()
	
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