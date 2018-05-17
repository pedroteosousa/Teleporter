extends Button

func _on_Restart_pressed():
	var universe = get_tree().get_current_scene()
	var tmp = universe.get_node("CurrentLevel")
	universe.remove_child(tmp)
	tmp.queue_free()
	universe.init()
	get_tree().paused = false