extends "res://scripts/levels/simple_level.gd"

var popup
var cur_message = 0
var WALLS_AMOUNT = 5
var walls = []


var messages = ["Now let's introduce the different balls\nyou can play with",
				"At the bottom of the screen you can see\nthe balls menu.",
				"It shows how many of each ball you still\ngot. Also your current ball is highlighted",
				"The first one is the ball you just threw\nin the previous level: Simple Ball",
				"Like the name says... it's a simple ball\nThis ball doesn't have any special effect",
				"Go ahead and try it out one more time\n",
				"",
				"...and teleport yourself to it",
				"This is Sticky Ball. It will stick to\nthe place it hits and stay there", #8
				"Throw it against the wall to check it out\n",
				"",
				"...and teleport yourself to it... again",
				"Dredd Ball: this is a ball that you can\nactually control while it moves!", #12
				"As soon as you throw it you can control\nits movement with the W/A/S/D keys",
				"Alternatively you may use the arrows too\nThis ball has a downside though...",
				"If it hits a wall the ball will disappear\nIt also dies if it travels for over 5 secs",
				"Now play around with it once!",
				"",
				"Hm, you know what to do at this point. If\nit died just press continue, don't worry",
				"By the way, the camera follows the ball\nso it's easier to keep track of it",
				"Crazy Ball: this is one crazy ball! Its\ntrajectory goes up and down over the time", #20
				"Oh! This ball also dies if it hits a wall\nHowever it doesn't have a time limit",
				"Anyway, go ahead and try it out and you\nwill see what I'm talking about",
				"",
				"You know the drill. Again, if it died\njust press continue. Don't worry!",
				"Okay, you've played with 4 of them\n3 to go, but let's continue later...",
				"Oh, scroll up/down to select ball. Choose\nby pressing 1, 2, 3, etc accordingly too",
				"Select the desired ball and\ngo ahead to the next level!"
				]

func init():
	balls = [["SimpleBall", -1], ["StickyBall", -1], ["DreddBall", -1], ["CrazyBall", -1], 
			 #["BalloonBall", -1], ["PoolBall", -1], ["BowlingBall", -1]
			]
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

	elif (cur_message <= 4):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			return show_message()

	elif (cur_message == 5):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and time_pressed == -1.0:
			time_pressed = elapsed_time
			return show_message()
	
	elif (cur_message == 6):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			time_pressed = elapsed_time - time_pressed
			create_ball(player.get_local_mouse_position().normalized()*get_intensity(time_pressed), player.velocity)
			time_pressed = -1.0	
			return show_message()
			
	elif (cur_message == 7):
		if InputMap.event_is_action(event, "teleport") and event.is_pressed():
			use_ball()
			current_ball += 1
			return show_message()
			
	elif (cur_message == 8):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			return show_message()
			
	elif (cur_message == 9):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and time_pressed == -1.0:
			time_pressed = elapsed_time
			return show_message()
	
	elif (cur_message == 10):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			time_pressed = elapsed_time - time_pressed
			create_ball(player.get_local_mouse_position().normalized()*get_intensity(time_pressed), player.velocity)
			time_pressed = -1.0	
			return show_message()
			
	elif (cur_message == 11):
		if InputMap.event_is_action(event, "teleport") and event.is_pressed():
			use_ball()
			current_ball += 1
			return show_message()
			
	elif (cur_message <= 15):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			return show_message()
			
	elif (cur_message == 16):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and time_pressed == -1.0:
			time_pressed = elapsed_time
			return show_message()
	
	elif (cur_message == 17):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			time_pressed = elapsed_time - time_pressed
			create_ball(player.get_local_mouse_position().normalized()*get_intensity(time_pressed), player.velocity)
			time_pressed = -1.0	
			return show_message()
			
	elif (cur_message == 18):
		if ((InputMap.event_is_action(event, "teleport") and event.is_pressed()) or (event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1)):
			use_ball()
			current_ball += 1
			return show_message()

	elif (cur_message <= 21):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			return show_message()
			
	elif (cur_message == 22):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and time_pressed == -1.0:
			time_pressed = elapsed_time
			return show_message()
	
	elif (cur_message == 23):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			time_pressed = elapsed_time - time_pressed
			create_ball(player.get_local_mouse_position().normalized()*get_intensity(time_pressed), player.velocity)
			time_pressed = -1.0	
			return show_message()
			
	elif (cur_message == 24):
		if ((InputMap.event_is_action(event, "teleport") and event.is_pressed()) or (event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1)):
			use_ball()
			return show_message()
			
	elif (cur_message == 25):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			return show_message()
			
	elif (cur_message == 26):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			return show_message()	
		for i in range(len(balls)):
			if InputMap.event_is_action(event, "ball_" + str(i)) and event.is_pressed():
				current_ball = i
		if InputMap.event_is_action(event, "change_current_ball_down") and event.is_pressed():
			current_ball = (current_ball-1+len(balls))%len(balls)
		if InputMap.event_is_action(event, "change_current_ball_up") and event.is_pressed():
			current_ball = (current_ball+1)%len(balls)
			
	elif (cur_message == 27):
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