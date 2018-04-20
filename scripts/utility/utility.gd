extends Area2D

export (String) var id = "0"

func enter():
	get_parent().get_parent().utility(id, true)

func exit():
	pass
func _physics_process(delta):
	for i in get_overlapping_bodies():
		enter()
		


