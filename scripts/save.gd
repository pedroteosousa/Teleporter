extends Node

const SAVE_PATH = "res://save.json"

func _ready():
	#load_game()
	#print(self.get_path())
	pass

func save_game():
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group('persistent')
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_line(JSON.print(save_dict))
	save_file.close()

func load_game():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		return
	save_file.open(SAVE_PATH, File.READ)
	var data = {}
	data = JSON.parse(save_file.get_as_text()).result
	for node_path in data.keys():
		var node = get_node(node_path)
		for attribute in data[node_path]:
			if attribute == "pos":
				node.global_position = Vector2(data[node_path]['pos']['x'],data[node_path]['pos']['y'])
			else:
				node.set(attribute, data[node_path][attribute])