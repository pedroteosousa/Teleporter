extends Node2D

export (String) var level_name = "Test Level"
# duration of level name being shown on screen
export (float) var label_duration = 3
# limiting size of the queue
export (int) var queue_size = 10
# true if level is a tutorial, false otherwise
export (bool) var tutorial = false

# array of usable balls in this level ([ball_name, quantity], if quantity = -1, you have infinite balls of that type)
var balls = [["SimpleBall", -1], ["DreddBall", -1], ["CrazyBall", -1], ["StickyBall", -1], ["BowlingBall", -1], ["PoolBall", -1], ["BalloonBall", -1]]
# current selected ball
var current_ball = 0

var ball_queue = []
var Ball = load("res://scripts/levels/ball_info.gd")

var ball_info_gui = []

var scenePath = "res://scenes/"

# joystick multiplier for speed
var joystick_speed = 300

# elapsed_time since the beginning of the level
var elapsed_time = 0

# time needed to fill the charge bar
var time_to_fill = 1.0

# level title label
var label
# the player character
var player

# the amount of time the button is pressed
var time_pressed = -1.0


# set list of balls
func init():
	pass

func utility():
	pass

func check_queue_availability(ball_name):
	# max ball quantity
	var mx_qtd = 0
	for info in balls:
		if ball_name == info[0]:
			mx_qtd = info[1]
	if mx_qtd < 0:
		return true
	var ball_qtd = 0
	for ball in ball_queue:
		if ball.ball_name == ball_name:
			ball_qtd += 1
	if ball_qtd < mx_qtd:
		return true
	else:
		return false

func clean_queue():
	var i = 0
	while i < len(ball_queue):
		if !ball_queue[i].obj or !ball_queue[i].obj.get_ref():
			if ball_queue[i].used:
				used(ball_queue[i].ball_name)
			ball_queue.remove(i)
		else:
			i += 1

func use_ball():
	clean_queue()
	if len(ball_queue):
		ball_queue[0].obj.get_ref().act(player)
		ball_queue[0].used = true

func create_ball(dir, vel):
	if len(ball_queue) >= queue_size:
		print('ball queue is full')
		return
	var ball_name = get_current_ball()
	if ball_name == null:
		return
	if check_queue_availability(ball_name):
		var new_ball = weakref(load(scenePath + "balls/" + ball_name + ".tscn").instance())
		new_ball.get_ref().set_position(player.get_position())
		new_ball.get_ref().go(dir, vel)
		ball_queue.append(Ball.new(ball_name, new_ball))
		add_child(new_ball.get_ref())
	else:
		print('too many balls of this type already in the queue')
		return

# called when player teleports
func used(ball_name):
	for ball in balls:
		if ball[0] == ball_name:
			ball[1] -= 1

# drawing color on top of the exit
func _draw():
	var exit = get_node("Exit")
	var polygon = exit.get_node("CollisionPolygon2D").polygon
	for i in range(polygon.size()):
		polygon.set(i, polygon[i] + exit.position)
	draw_colored_polygon(polygon, Color(1,0.6,0.6,0.5))

func get_intensity(elapsed):
	var period = 2*PI/time_to_fill
	return (-cos(elapsed*period+PI/2.0)+1.0)/2.0

func _unhandled_input(event):
	if (tutorial == true):
		return
	# change current selected ball
	# select by number keys
	for i in range(len(balls)):
		if InputMap.event_is_action(event, "ball_" + str(i)) and event.is_pressed():
			current_ball = i
	# select by scroll wheel
	if InputMap.event_is_action(event, "change_current_ball_down") and event.is_pressed():
		current_ball = (current_ball-1+len(balls))%len(balls)
	if InputMap.event_is_action(event, "change_current_ball_up") and event.is_pressed():
		current_ball = (current_ball+1)%len(balls)
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and time_pressed == -1.0:
		time_pressed = elapsed_time
	
	if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
		time_pressed = elapsed_time - time_pressed
		create_ball(player.get_local_mouse_position().normalized()*get_intensity(time_pressed), player.velocity)
		time_pressed = -1.0
	
	# release ball with mouse
	#if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
	#	create_ball(player.get_local_mouse_position(), player.velocity)
	# release ball with joystick
	if InputMap.event_is_action(event, "release_joystick") and event.is_pressed() and !event.is_echo():
		var direction = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX), Input.get_joy_axis(0, JOY_ANALOG_LY))
		create_ball(direction*joystick_speed, player.velocity)
	
	# use ball
	if InputMap.event_is_action(event, "teleport") and event.is_pressed():
		use_ball()

func _process(delta):
	update_balls()
	clean_queue()
	
	# calculating elapsed time to be used in various situations
	elapsed_time += delta
	
	# showing label with level title at level start
	if elapsed_time <= label_duration:
		var alpha = 1-(2*abs(label_duration/2.0 - elapsed_time)) / (label_duration)
		label.add_color_override("font_color", Color(.576, .80, .918, alpha))
	elif elapsed_time > label_duration and label_duration > 0:
		label_duration = -1
		label.hide()
	
	# checking if level was completed
	var exit = get_node("Exit")
	if exit.get_overlapping_bodies().size() != 0:
		completed()

# return the name of the current selected ball
func get_current_ball():
	var ball_info = balls[current_ball]
	if ball_info[1] < 0 or ball_info[1] >= 1:
		return ball_info[0]
	else:
		print("ball limit exceeded")
		return null

# update balls on HUD
func update_balls():
	for i in range(len(balls)):
		ball_info_gui[i].get_node('Selected').hide()
		if balls[i][1] >= 0:
			ball_info_gui[i].get_node('Amount').text = str(balls[i][1])
	
	# select current ball
	ball_info_gui[current_ball].get_node('Selected').show()

# this function is called when user completes the level
func completed():
	print("level finished in " + str(elapsed_time) + " seconds")
	get_parent().completed_level()
	queue_free()

func get_size_from_sprite(object):
	var sprite = object.get_node("Sprite")
	return sprite.get_texture().get_size() / Vector2(sprite.hframes, sprite.vframes)

# reading all tilesmaps and translating dummy cells
func load_map():
	for map in get_children():
		if !(map is TileMap):
			continue
		var tileset = map.tile_set
		for cell in map.get_used_cells():
			var tile = map.get_cell(cell.x, cell.y)
			var name = tileset.tile_get_name(tile)
			var path = scenePath + map.get_name() + "/" + name + ".tscn"
			var object = load(path).instance()
			var pos = cell * map.cell_size.x + get_size_from_sprite(object)/2
			object.set_position(pos)
			add_child(object)
			if map.get_name() == 'player':
				player = object
		map.hide()

func set_message():
	pass
	
func wait_for_input():
	pass

func _ready():
	# get list of balls
	init()
	
	load_map()
	# positioning lavel on correct position
	label = get_node("HUD/Level Name")
	label.rect_position.y = get_viewport_rect().size.y/4
	label.rect_size.x = get_viewport_rect().size.x
	label.text = level_name
	
	# setting ball info display
	var ball_bar = get_node("HUD/Ball Display/Background")
	print(ball_bar)
	var ball_display_scene = load(scenePath + 'gui/BallInfo.tscn')
	for ball in balls:
		var info = ball_display_scene.instance()
		ball_info_gui.append(info)
		ball_bar.add_child(info)
		
		# setting control position
		info.set_position(Vector2((len(ball_info_gui)-1)*(info.get_size().x), 0))
		
		# setting image texture
		var ball_texture = load(scenePath + "balls/" + ball[0] + ".tscn").instance().get_node('Sprite').texture
		info.get_node('Image').texture = ball_texture
		
		# setting ball amount
		if ball[1] >= 0:
			info.get_node('Amount').text = str(ball[1])
	
	set_process(true)
	set_process_unhandled_input(true)