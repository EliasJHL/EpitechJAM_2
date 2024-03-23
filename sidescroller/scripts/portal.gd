extends Area2D

var portalpos: Vector2
var portal_rotation: float
var haut = Vector2(0.707107, -0.707107)
var haut2 = Vector2(-0.707107, -0.707107)

func _ready():
	portalpos = get_node("../portal2/Marker2D").global_position
	portal_rotation = get_node("../portal2").rotation

func check_gravity(jump_direction):
	if jump_direction <= haut && jump_direction >= haut2:
		print("haut")
	print("jump", jump_direction)

func _on_body_entered(body):
	if body.name == "Player":
		body.global_position = portalpos
		var jump_direction = Vector2.RIGHT.rotated(portal_rotation)
		check_gravity(jump_direction)
		body.velocity = jump_direction * 700
		Global.take_portal = true
