extends Area2D

func enemy_collision():
	queue_free()

func _physics_process(delta):
	for i in get_overlapping_bodies():
		i.enemy_collision()