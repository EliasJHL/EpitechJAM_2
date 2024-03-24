extends Area2D

func _on_Area2D_body_entred(body: Node) -> void:
	if "Player" in body.name:
		body.global_position = Vector2(25, 0)
