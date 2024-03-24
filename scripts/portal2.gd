extends Area2D

var portalpos: Vector2
var portal_rotation: float
var haut = Vector2(0.707107, -0.707107)
var haut2 = Vector2(-0.707107, -0.707107)
var droite = Vector2(-0.70711, 0.707104)

func _ready():
	pass
	#portalpos = get_tree().current_scene.get_node("portal1/Marker2D").global_position
	#portal_rotation = get_tree().current_scene.get_node("portal1").rotation

func check_gravity(jump_direction):
	if round(rad_to_deg(jump_direction.angle())) >= -45 && round(rad_to_deg(jump_direction.angle())) <= 45:
		Global.gravity = 2
	if round(rad_to_deg(jump_direction.angle())) >= 135 || round(rad_to_deg(jump_direction.angle())) <= -135:
		Global.gravity = 3
	if round(rad_to_deg(jump_direction.angle())) >= 45 && round(rad_to_deg(jump_direction.angle())) <= 135:
		Global.gravity = 0
	if round(rad_to_deg(jump_direction.angle())) >= -135 && round(rad_to_deg(jump_direction.angle())) <= -45:
		Global.gravity = 1

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
		var jump_direction = Vector2.UP.rotated(portal_rotation)
		print(round(rad_to_deg(jump_direction.angle())))
		check_gravity(jump_direction)
		if body.name == "player":
			body.velocity = jump_direction * 300
		Global.take_portal = true
		get_tree().current_scene.get_node("portal2/Timer").start()
