extends "res://scripts/levels/simple_level.gd"

var popup
var cur_message = 0
var WALLS_AMOUNT = 5
var walls = []

var messages = ["Welcome to the tutorial!\nClick on mouse left button to continue", #0
				"You will be given the basic instructions\nto play the game now",
				"Let's throw a ball. The direction of the\nthrow is based on your mouse position",
				"Hold the left button of the mouse to throw\nthe ball with the desired force!",
				"The force bar will go up and down. Release\nthe left mouse button to throw the ball!",
				"You may teleport yourself to the ball\nPress the right mouse button to do so!",
				"Great! That's the basic mechanic of\nthe game. But... what's the goal?",
				"Well. This is the exit. Every level of\nthe game has one. Basically, find it and\nteleport yourself there",
				"One more thing: you may jump by pressing\nspace when you are on the floor. Try it!",
				"That's it for now. Get outta here!\nLet me help and remove that wall for you...",
				"There you go!\nTeleport yourself to the exit!"
				]

func init():
	balls = [["SimpleBall", -1]]
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
	
	elif (cur_message <= 2):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			return show_message()
			
	elif (cur_message == 3):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and time_pressed == -1.0:
			time_pressed = elapsed_time
			return show_message()
	
	elif (cur_message == 4):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			time_pressed = elapsed_time - time_pressed
			create_ball(player.get_local_mouse_position().normalized()*get_intensity(time_pressed), player.velocity)
			time_pressed = -1.0	
			return show_message()
			
	elif (cur_message == 5):
		if InputMap.event_is_action(event, "teleport") and event.is_pressed():
			use_ball()
			return show_message()
			
	elif (cur_message == 6):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			player.get_node("Camera2D").zoom = Vector2(0.5,0.5)
			player.get_node("Camera2D").position = 32*Vector2(24.5,2.5) - player.get_position()
			return show_message()

	elif (cur_message == 7):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			player.follow_ball()
			return show_message()
			
	elif (cur_message == 8):
		if player.is_on_floor():
			if Input.is_key_pressed(KEY_SPACE):
				player.velocity.y -= 150
				return show_message()
			
	elif (cur_message == 9):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			for i in range (WALLS_AMOUNT):
				walls[i].queue_free()
			return show_message()
			
			
	elif (cur_message == 10):
		return false
			
	#last one:
		#if blablabla
			#popup.hide()
			#return false
	
	return true


func _unhandled_input(event):
	if(!wait_for_input(event)):
		tutorial = false