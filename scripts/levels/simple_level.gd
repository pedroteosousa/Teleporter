extends Node2D

export (String) var level_name = "Test Level"
# duration of level name being shown on screen
export (float) var label_duration = 3

# array of usable balls in this level ([ball_name, quantity], if quantity = -1, you have infinite balls of that type)
var balls = [["SimpleBall", -1], ["DreddBall", -1], ["CrazyBall", -1], ["StickyBall", -1], ["BowlingBall", -1], ["PoolBall", -1], ["BalloonBall", -1]]
# current selected ball
var current_ball = 0

var ball_queue = []
var Ball = load("res://scripts/levels/ball_info.gd")

var scenePath = "res://scenes/"

# joystick multiplier for speed
var joystick_speed = 300

# elapsed_time since the beginning of the level
var elapsed_time = 0

# level title label
var label
# the player character
var player

func utility():
	pass

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
	print(ball_queue)
	if len(ball_queue):
		ball_queue[0].obj.get_ref().act(player)
		ball_queue[0].used = true

func create_ball(dir, vel):
	var ball_name = get_current_ball()
	if ball_name == null:
		return
	var new_ball = weakref(load(scenePath + "balls/" + ball_name + ".tscn").instance())
	new_ball.get_ref().set_position(player.get_position())
	new_ball.get_ref().go(dir, vel)
	ball_queue.append(Ball.new(ball_name, new_ball))
	add_child(new_ball.get_ref())

# called when player teleports
func used(ball_name):
	for ball in balls:
		if ball[0] == ball_name:
			ball[1] -= 1

# drawing color on top of the exit
func _draw():
	var exit = get_node("Exit")
	var polygon = exit.get_node("CollisionPolygon2D").polygon
	print(polygon)
	for i in range(polygon.size()):
		polygon.set(i, polygon[i] + exit.position)
	draw_colored_polygon(polygon, Color(1,0.6,0.6,0.5))

func _unhandled_input(event):
	# change current selected ball
	# select by number keys
	for i in range(len(balls)):
		if InputMap.event_is_action(event, "ball_" + str(i)) and event.is_pressed():
			current_ball = i 
			update_current_ball()
	# select by scroll wheel
	if InputMap.event_is_action(event, "change_current_ball_down") and event.is_pressed():
		current_ball = (current_ball-1+len(balls))%len(balls)
		update_current_ball()
	if InputMap.event_is_action(event, "change_current_ball_up") and event.is_pressed():
		current_ball = (current_ball+1)%len(balls)
		update_current_ball()
	
	# release ball with mouse
	if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
		create_ball(player.get_local_mouse_position(), player.velocity)
	# release ball with joystick
	if InputMap.event_is_action(event, "release_joystick") and event.is_pressed() and !event.is_echo():
		var direction = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX), Input.get_joy_axis(0, JOY_ANALOG_LY))
		create_ball(direction*joystick_speed, player.velocity)
	
	# use ball
	if InputMap.event_is_action(event, "teleport") and event.is_pressed():
		use_ball()

func _process(delta):
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

# updates current ball on HUD
func update_current_ball():
	var ball = load(scenePath + "balls/" + balls[current_ball][0] + ".tscn").instance()
	var ball_sprite = ball.get_node('Sprite')
	get_node("HUD/Ball Display/Image").texture = ball_sprite.texture
	get_node("HUD/Ball Display/Label").text = ball.ball_name

# this function is called when user completes the level
func completed():
	print("level finished in " + str(elapsed_time) + " seconds")
	queue_free()
	get_tree().change_scene("res://scenes/gui/MainMenu.tscn")

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

func _ready():
	load_map()
	update_current_ball()
	# positioning lavel on correct position
	label = get_node("HUD/Level Name")
	label.rect_position.y = get_viewport_rect().size.y/4
	label.rect_size.x = get_viewport_rect().size.x
	label.text = level_name
	
	set_process(true)
	set_process_unhandled_input(true)
