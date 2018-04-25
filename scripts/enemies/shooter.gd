extends "res://scripts/enemies/simple_enemy.gd"

# shooting to the right
export (float) var angle = 0
export (float) var frequency = 2

var projectile = "res://scenes/enemies/Projectile.tscn"

func action(delta):
	if (elapsed_time > frequency):
		elapsed_time = 0
		var dir = Vector2(1, 0).rotated(angle)
		var object = load(projectile).instance()
		object.dir = dir
		add_child(object)
		
func _ready():
	# converting to radians
	angle = (angle / 180) * PI