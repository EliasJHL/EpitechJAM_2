extends RigidBody2D

const blue_path = preload("res://blue_portal.tscn")
const orange_path = preload("res://orange_portal.tscn")

static var created_walls_b = []
static var created_walls_o = []

var blue = false
var orange = false

# Called when the node enters the scene tree for the first time.
func _ready():
	blue = true
	orange = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	pass

#Gestion de contact avec un mur compatible
func _on_area_2d_body_entered(body):
	if body.is_in_group("Portail_OK") and self.blue:
		call_deferred("_create_portal_blue", blue_path)
	elif body.is_in_group("Portail_OK") and self.orange:
		call_deferred("_create_portal_orange", orange_path)

func _create_portal_orange(portal_path):
	var portal = portal_path.instantiate()
	portal.global_position = self.global_position
	#portal.global_rotation = self.global_rotation Rotation du portail
	get_tree().get_root().add_child(portal)
	created_walls_o.append(portal)
	self.queue_free()

func _create_portal_blue(portal_path):
	var portal = portal_path.instantiate()
	portal.global_position = self.global_position
	#portal.global_rotation = self.global_rotation Rotation du portail
	get_tree().get_root().add_child(portal)
	created_walls_b.append(portal)
	self.queue_free()

#Ajout d'un timer pour que la balle despawn au bout de 5s
func _on_timer_timeout():
	queue_free()
