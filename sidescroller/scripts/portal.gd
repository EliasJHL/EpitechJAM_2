extends Area2D

var portalpos: Vector2
var portal_rotation: float
var has_taken_portal = false

func _ready():
	portalpos = get_node("../portal2/Marker2D").global_position
	portal_rotation = get_node("../portal2").rotation

func _on_body_entered(body):
	if body.name == "Player":
		body.global_position = portalpos
		var jump_direction = Vector2.RIGHT.rotated(portal_rotation)
		body.velocity = jump_direction * 700
		Global.take_portal = true
