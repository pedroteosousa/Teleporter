extends Control

var button = null

func is_enabled(x):
	button.disabled = !x
	button.get_node("Label").visible = x

func init(v):
	button.get_node("Label").text = str(v)

func _ready():
	button = get_node("MarginContainer/Button")