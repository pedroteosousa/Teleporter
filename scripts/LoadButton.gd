extends Button

onready var save = get_node('/root/save')

func _on_LoadButton_pressed():
	print("click on load")
	save.load_game()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
