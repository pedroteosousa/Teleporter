extends "res://scripts/balls/simple_ball.gd"

func collided(collision):
	queue_free()
	
func ball_timeout():
	print(elapsed_time)
	if (elapsed_time >= destroy_time):
		queue_free()
		
func go(dir, vel):
	velocity = limit_velocity(dir) + vel
	if abs(dir.x) > abs(dir.y):
		dir.y = 0
	else:
		dir.x = 0
	change_direction(dir.normalized())
	
func change_direction(dir):
	self.rotation = dir.angle()
	velocity = dir*velocity.length()

func _unhandled_input(event):
	if InputMap.event_is_action(event, "ui_down") and event.is_pressed():
		change_direction(Vector2(0,1))
	if InputMap.event_is_action(event, "ui_left") and event.is_pressed():
		change_direction(Vector2(-1,0))
	if InputMap.event_is_action(event, "ui_right") and event.is_pressed():
		change_direction(Vector2(1,0))
	if InputMap.event_is_action(event, "ui_up") and event.is_pressed():
		change_direction(Vector2(0,-1))