extends "res://scripts/balls/simple_ball.gd"

func collided():
	queue_free()
	
func ball_timeout():
	print(elapsed_time)
	if (elapsed_time >= destroy_time):
		queue_free()

func _unhandled_input(event):
	if InputMap.event_is_action(event, "ui_down"):
		velocity = Vector2(0,1)*velocity.length()
	if InputMap.event_is_action(event, "ui_left"):
		velocity = Vector2(-1,0)*velocity.length()
	if InputMap.event_is_action(event, "ui_right"):
		velocity = Vector2(1,0)*velocity.length()
	if InputMap.event_is_action(event, "ui_up"):
		velocity = Vector2(0,-1)*velocity.length()

func _ready():
	pass