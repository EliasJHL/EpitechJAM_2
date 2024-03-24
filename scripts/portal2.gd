extends Area2D

var portalpos: Vector2
var portal_rotation: float
var haut = Vector2(0.707107, -0.707107)
var haut2 = Vector2(-0.707107, -0.707107)

func _ready():
	pass
	#portalpos = get_tree().current_scene.get_node("portal1/Marker2D").global_position
	#portal_rotation = get_tree().current_scene.get_node("portal1").rotation

func check_gravity(jump_direction):
	if jump_direction <= haut && jump_direction >= haut2:
		print("haut")
	print("jump", jump_direction)

func _on_body_entered(body):
	portalpos = get_tree().current_scene.get_node("portal1/Marker2D").global_position
	portal_rotation = get_tree().current_scene.get_node("portal1").rotation
	if !get_tree().current_scene.get_node("portal2/Timer").is_stopped:
		print("STOP")
		return
	if body.name == "player" or body.is_in_group("Object"):
		var pos_dest = portalpos
		pos_dest.y -= 5
		pos_dest.x -= 2
		body.global_position = pos_dest
		var jump_direction = Vector2.RIGHT.rotated(portal_rotation)
		check_gravity(jump_direction)
		if body.name == "player":
			body.velocity = jump_direction * 140
		Global.take_portal = true
		get_tree().current_scene.get_node("portal2/Timer").start()
