extends RigidBody2D

const blue_path = preload("res://scripts/portal2.tscn")
const orange_path = preload("res://scripts/portal1.tscn")

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
		call_deferred("_create_portal_blue", blue_path, body)
	elif body.is_in_group("Portail_OK") and self.orange:
		call_deferred("_create_portal_orange", orange_path, body)
	elif body.is_in_group("Player_Body"):
		queue_free()

func _create_portal_orange(portal_path, body):
	var portal1 = get_tree().current_scene.get_node("portal1")
	portal1.global_position = self.global_position
	portal1.global_rotation = body.global_rotation #Rotation du portail
	self.queue_free()

func _create_portal_blue(portal_path, body):
	var portal2 = get_tree().current_scene.get_node("portal2")
	portal2.global_position = self.global_position
	portal2.global_rotation = body.global_rotation #Rotation du portail
	self.queue_free()

#Ajout d'un timer pour que la balle despawn au bout de 5s
func _on_timer_timeout():
	queue_free()
