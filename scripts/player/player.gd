extends KinematicBody2D

var gravity = Vector2(0, 100)
var velocity = Vector2(0, 0)

var current_ball = null
var is_dredd = false

# should camera follow the ball
var should_follow = false

var level

func get_current_ball():
	var n = len(get_parent().ball_queue)
	if n != 0:
			if get_parent().ball_queue[n-1].ball_name == "DreddBall":
				current_ball = get_parent().ball_queue[n-1].obj
				is_dredd = true
			else:
				current_ball = get_parent().ball_queue[0].obj
				is_dredd = false
	else:
		current_ball = null
		is_dredd = false

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
	if level.level_name == "Tutorial Level 4":
		print(":D")
		set_position(32*Vector2(17.5, 4.5))
	else:
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
	print('is_dredd = ' + str(is_dredd))
	print('should_follow = ' + str(should_follow))
	if should_follow or is_dredd:
		if current_ball and	current_ball.get_ref():
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
	else:
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