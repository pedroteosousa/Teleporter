extends Node2D

export (String) var level_name = "Test Level"
# duration of level name being shown on screen
export (float) var label_duration = 3

# array of usable balls in this level ([ball_name, quantity], if quantity = -1, you have infinite balls of that type)
var balls = [["DreddBall", -1], ["SimpleBall", -1], ["CrazyBall", -1], ["StickyBall", -1], ["BowlingBall", -1], ["PoolBall", -1], ["BalloonBall", -1]]
var current_ball = 0

var scenePath = "res://scenes/"

# elapsed_time since the beginning of the level
var elapsed_time = 0

# level title label
var label
# the player character
var player

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
		polygon.set(i, polygon[i] + exit.transform.get_origin())
	draw_colored_polygon(polygon, Color(1,0.6,0.6,0.5))

func _unhandled_input(event):
	# change current selected ball
	if InputMap.event_is_action(event, "change_current_ball_down") and event.is_pressed():
		current_ball = (current_ball-1+len(balls))%len(balls)
		update_current_ball()
	if InputMap.event_is_action(event, "change_current_ball_up") and event.is_pressed():
		current_ball = (current_ball+1)%len(balls)
		update_current_ball()

func _process(delta):
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
			var pos = cell * map.cell_size.x + Vector2(1,1)*(map.cell_size.x/2)
			print(pos)
			var object = load(path).instance()
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
