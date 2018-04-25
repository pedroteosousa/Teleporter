extends "res://scripts/enemies/simple_enemy.gd"

# direction of walk
export (float) var angle = 0
# size of the walk in number of 32 pixel blocks
export (float) var walk_size = 5
export (int) var speed = 100

# direction of walk
var direction = Vector2(1, 0)
# error in position check
var epsilon = 0.01
# start and end location
var start_location
var end_location

# when true, object is going from start location to end location
var going = true

func action(delta):
	if position.distance_to(start_location) < epsilon:
		going = true
	if position.distance_to(end_location) < epsilon:
		going = false
	
	if going:
		position += direction * delta * speed
	else:
		position += Vector2(-direction.x, -direction.y) * delta * speed
	
func _ready():
	walk_size *= 32
	
	angle = (angle / 180.0) * PI
	direction = direction.rotated(angle)
	
	start_location = position
	end_location = position + walk_size * direction