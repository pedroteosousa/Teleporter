extends Area2D

export (String) var id = "1"

func enter():
	get_parent().get_parent().utility(id, true)

func exit():
	get_parent().get_parent().utility(id, false)

func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	if (!overlapping_bodies.size()): exit()
	for i in overlapping_bodies:
		enter()