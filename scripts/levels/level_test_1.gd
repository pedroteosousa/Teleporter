extends "res://scripts/levels/simple_level.gd"

var wall1 = []
var wall2 = []
var is_alive_1 = 0
var is_alive_2 = 0
var WALLS1_AMOUNT = 4
var WALLS2_AMOUNT = 3
var hidden_utility

func init():
	balls = [["SimpleBall", 3], ["StickyBall", 2]]


func utility(id, enter):
	if (enter):
		if (id == "0"):
			if (is_alive_1):
				for i in range (WALLS1_AMOUNT):
					wall1[i].queue_free()
				hidden_utility.hide()
				hidden_utility.id = "!"
			is_alive_1 = 0

		if (id == "1"):
			if (is_alive_2):
				for i in range (WALLS2_AMOUNT):
					wall2[i].queue_free()
			is_alive_2 = 0

	else:
		if (id == "0"):
			if (!is_alive_1):
				for i in range (WALLS1_AMOUNT):
					wall1[i] = load("res://scenes/walls/SimpleWall.tscn").instance()
					wall1[i].set_position(32.0*Vector2(13.0, 0.0+i))
					add_child(wall1[i])
				is_alive_1 = 1
				hidden_utility.show()
				hidden_utility.id = "1"

		if (id == "1"):
			if (!is_alive_2):
				for i in range (WALLS2_AMOUNT):
					wall2[i] = load("res://scenes/walls/SimpleWall.tscn").instance()
					wall2[i].set_position(32.0*Vector2(14.0+i, 3.0))
					add_child(wall2[i])
				is_alive_2 = 1


func _ready():
	hidden_utility = get_node("Utility").get_node("Utility2")
	
	for i in range (WALLS1_AMOUNT):
		wall1.append(null)
	for i in range (WALLS2_AMOUNT):
		wall2.append(null)
		
	if (!is_alive_2):
		for i in range (WALLS2_AMOUNT):
			wall2[i] = load("res://scenes/walls/SimpleWall.tscn").instance()
			wall2[i].set_position(32.0*Vector2(14.0+i, 3.0))
			add_child(wall2[i])
		is_alive_2 = 1