extends "res://scripts/levels/simple_level.gd"

var popup
var cur_message = 0
var destructible_wall = null


var messages = ["I know you're tired of the tutorial,\nbut I promise this is the last one!",
				"In this level there's fire! If a ball\nhits it, the ball instantly disappears",
				"If you die, the level restarts though\n",
				"Anyway, back to the walls! The simplest\none is that blue wall you've been seeing",
				"They simply don't let anything through\nand are unbreakable",
				"The other 2 walls are permeable: one to\nplayers and the other to balls",
				"On your right you can see two blocks of\nwalls: dark-blue walls and beige walls",
				"Dark-blue walls: any ball can go through\nBeige walls: only the player goes through",
				"I believe you can do this already...\nComplete this level!",
				]

func init():
	balls = [["SimpleBall", -1], ["StickyBall", -1], ["DreddBall", -1], ["CrazyBall", -1], 
			 ["BalloonBall", -1], ["PoolBall", -1], ["BowlingBall", -1]
			]
	popup = get_node("Popup/Text")
	popup.rect_position.y = get_viewport_rect().size.y*(3/4)
	popup.rect_size.x = get_viewport_rect().size.x
	popup.text = messages[0]
	popup.show()
	

func show_message():
	popup.hide()
	cur_message += 1
	popup.text = messages[cur_message]
	popup.show()
	return true


func wait_for_input(event):
	if (cur_message > len(messages)):
		return false

	elif (cur_message <= 7):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			return show_message()
	
	elif (cur_message == 8):
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == 1:
			popup.hide()
			cur_message += 2
			return true
	
	return true


func _unhandled_input(event):
	if(!wait_for_input(event)):
		tutorial = false