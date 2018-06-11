extends Area2D

export (int) var id
export (Vector2) var normal = Vector2(0,1)
var ignore = false

func _ready():
	connect("body_entered", self, "teleport")
	
func teleport(body):
	if body.collision_layer == 2:
		if ignore:
			ignore = false
			return
		for portal in get_parent().get_children():
			if portal.id == id and portal.get_instance_id() != self.get_instance_id():
				portal.ignore = true
				body.position = portal.position
				body.velocity = body.velocity.reflect(normal)
				break