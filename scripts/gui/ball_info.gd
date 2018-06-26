extends Control

export (float) var time = 0.1
var elapsed_time = time

func warn():
	elapsed_time = 0

func _process(delta):
	elapsed_time += delta
	get_node("Warning").visible = (elapsed_time < time)