extends "res://scripts/enemies/simple_enemy.gd"

# vector poiting to the right
export (Vector2) var direction = Vector2(1, 0)
export (int) var speed = 300

func action(delta):
	position += direction*delta*speed
	
func overlapping_with_body(body):
	queue_free()
	
func _physics_process(delta):
	for i in get_overlapping_bodies():
		overlapping_with_body(i)