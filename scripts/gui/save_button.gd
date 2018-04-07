extends Button

onready var save = get_node('/root/save')

func _on_SaveButton_pressed():
	save.save_game()