extends Area2D

var elapsed_time = 0.0

func action(delta):
	pass

func enemy_collision():
	queue_free()
	
func overlapping_with_body(body):
	pass

func _physics_process(delta):
	# updating elapsed time
	elapsed_time += delta
	
	# do something
	action(delta)
	
	for i in get_overlapping_bodies():
		i.enemy_collision()