extends KinematicBody2D

var gravity = Vector2(0, 100)
var velocity = Vector2(0, 0)

var current_ball = null

# should camera follow the ball
var should_follow = false

var level

func get_current_ball():
	if len(get_parent().ball_queue):
		current_ball = get_parent().ball_queue[0].obj
	else:
		current_ball = null

func _unhandled_input(event):
	# jump
	if InputMap.event_is_action(event, "jump") and is_on_floor() and !level.tutorial:
		velocity.y -= 150
		$JumpFX.play()
	
	# make camera follow the current ball
	if InputMap.event_is_action(event, "follow_ball"):
		if event.is_pressed():
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
	var universe = get_tree().get_current_scene()
	universe.restart_level()
	queue_free()
	
func update_charge_bar(filled):
	self.get_child(4).show()
	self.get_child(3).show()
	self.get_child(3).set_scale(Vector2(filled, 1))

func _physics_process(delta):
	get_current_ball()

	# gravity
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	#update charge bar
	if level.time_pressed != -1.0:
		update_charge_bar(level.get_intensity(level.elapsed_time-level.time_pressed))
	else:
		self.get_child(3).hide()
		self.get_child(4).hide()
	
	# update camera behaviour
	if should_follow:
		if current_ball and current_ball.get_ref():
			var screen_size = get_viewport_rect().size
			var dist = current_ball.get_ref().get_position() - get_position()
			var zoom = max(1.0, max(2*abs(dist.x / screen_size.x), 2*abs(dist.y / screen_size.y)))
			follow_ball(dist/2.0, Vector2(zoom, zoom), true)
		else:
			var screen_size = get_viewport_rect().size
			var dist = get_parent().center - get_position()
			var zoom = max(1.0, 1.3*max(abs(get_parent().size.x / screen_size.x), abs(get_parent().size.y / screen_size.y)))
			follow_ball(dist, Vector2(zoom, zoom), true)
			pass
	elif should_follow:
		should_follow = false
		follow_ball()

func _ready():
	self.get_child(3).hide()
	self.get_child(4).hide()
	set_physics_process(true)
	set_process_input(true)
	level = get_parent()
	
	#get_intensity

func save():
	var save_dict = {
		pos = {
			x = global_position.x,
			y = global_position.y
		}
	}
	return save_dict