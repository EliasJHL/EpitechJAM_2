extends RigidBody2D

const portal_path = preload("res://blue_portal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	pass

#Gestion de contact avec un mur compatible
func _on_area_2d_body_entered(body):
	if body.is_in_group("Portail_OK"):
		var portal = portal_path.instantiate()
		portal.global_position = self.global_position
		portal.global_rotation = self.global_rotation
		get_tree().get_root().add_child(portal)
		queue_free()
		

#Ajout d'un timer pour que la balle despawn au bout de 5s
func _on_timer_timeout():
	queue_free()
