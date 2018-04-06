extends Button

func _on_PauseButton_pressed():
	get_tree().paused = !get_tree().paused
