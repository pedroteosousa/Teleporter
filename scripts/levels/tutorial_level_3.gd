extends "res://scripts/levels/simple_level.gd"

var popup
var cur_message = 0
var WALLS_AMOUNT = 5
var walls = []
var destructible_wall = null
var wk = null


var messages = ["Alright, let's introduce the other 3 balls",
				"This is Balloon Ball. It only goes up and\nits speed increases over time",
				"Also, the throw force doesn't matter\nThrow it to check it out!",
				"",
				"It slowly goes up, as mentioned...\nTeleport yourself!",
				"Pool Ball: this ball isn't affected\nby gravity", #5
				"Also its speed goes down\nsignificantly when it hits an obstacle",
				"Check it out",
				"",
				"You know what to do!",
				"Finally, the last one: Bowling Ball\n", #10
				"This ball has the ability to break walls\nBut not every wall...",
				"While we are it, let's talk about walls\nLet me do something...",
				"Alright. This is a destructible wall\nIt can be broken by the bowling ball",
				"Throw it as strong as you can to\ndestroy it!",
				"Throw it as strong as you can to\ndestroy it!",
				"Throw it as strong as you can to\ndestroy it!",
				"You did it! There are three more kinds\nof walls", #17
				"But let's check them in the next level\n",
				"Reach the exit!",
				]

func init():
	balls = [["BalloonBall", -1], ["PoolBall", -1], ["BowlingBall", -1]]
	popup = get_node("Popup/Text")
	popup.rect_position.y = get_viewport_rect().size.y*(3/4)
	popup.rect_size.x = get_viewport_rect().size.x
	popup.text = messages[0]
	popup.show()
	
	for i in range (WALLS_AMOUNT):
		walls.append(null)
		walls[i] = load("res://scenes/walls/SimpleWall.tscn").instance()
		walls[i].set_position(32.0*Vector2(21.5, 0.5+i))
		add_child(walls[i])


func show_message():
	popup.hide()
	cur_message += 1
	popup.text = messages[cur_message]
	popup.show()
	return true


func wait_for_input(event):
	if (cur_message > len(messages)):
		return false

	elif (cur_message <= 1):
		if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE):
			return show_message()

	elif (cur_message == 2):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and time_pressed == -1.0:
			time_pressed = elapsed_time
			return show_message()
	
	elif (cur_message == 3):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			time_pressed = elapsed_time - time_pressed
			create_ball(player.get_local_mouse_position().normalized()*get_intensity(time_pressed), player.velocity)
			time_pressed = -1.0	
			return show_message()
			
	elif (cur_message == 4):
		if InputMap.event_is_action(event, "teleport") and event.is_pressed():
			use_ball()
			current_ball += 1
			return show_message()
			
	elif (cur_message <= 6):
		if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE):
			return show_message()
			
	elif (cur_message == 7):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and time_pressed == -1.0:
			time_pressed = elapsed_time
			return show_message()
	
	elif (cur_message == 8):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			time_pressed = elapsed_time - time_pressed
			create_ball(player.get_local_mouse_position().normalized()*get_intensity(time_pressed), player.velocity)
			time_pressed = -1.0	
			return show_message()
			
	elif (cur_message == 9):
		if InputMap.event_is_action(event, "teleport") and event.is_pressed():
			use_ball()
			current_ball += 1
			return show_message()
	
	elif (cur_message <= 11):
		if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE):
			return show_message()
	
	elif (cur_message == 12):
		if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE):
			destructible_wall = load("res://scenes/walls/DestructibleWall.tscn").instance()
			destructible_wall.set_position(32.0*Vector2(15.5, 2.5))
			wk = weakref(destructible_wall)
			add_child(destructible_wall)
			player.get_node("Camera2D").zoom = Vector2(0.5,0.5)
			player.get_node("Camera2D").position = 32*Vector2(15.5 ,2.5) - player.get_position()
			return show_message()
			
	elif (cur_message == 13):
		if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE):
			player.follow_ball()
			return show_message()
			
	elif (cur_message == 14):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and time_pressed == -1.0:
			time_pressed = elapsed_time
			return show_message()
		
	
	elif (cur_message == 15):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			time_pressed = elapsed_time - time_pressed
			create_ball(player.get_local_mouse_position().normalized()*get_intensity(time_pressed), player.velocity)
			time_pressed = -1.0
			return show_message()
			
	elif (cur_message == 16):
		if wk.get_ref():
			cur_message -= 3
		#else:
		#	player.get_current_ball()
		#	while (player.current_ball != null):
		#		player.current_ball.queue_free()
		#		player.get_current_ball()
		return show_message()
	
	elif (cur_message <= 18):
		if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE):
			return show_message()
			
	elif (cur_message == 19):
		for i in range (WALLS_AMOUNT):
			walls[i].queue_free()
		cur_message += 1
		return false
	#last one:
		#if blablabla
			#popup.hide()
			#return false
	
	return true


func _unhandled_input(event):
	if(!wait_for_input(event)):
		tutorial = false