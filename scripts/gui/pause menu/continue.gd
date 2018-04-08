extends Button

func _on_continue_pressed():
	get_tree().paused = !get_tree().paused
