extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#assets dont j'ai besoin pour l'arme
const bullet_path = preload("res://bullet.tscn")

#Fonction pour le viseur de l'arme
func _process(delta):
	var target_position = get_global_mouse_position()
	#Regard sur la souris → Il est basé sur le centre du joueur
	$Weapon_rotation.look_at(target_position)

#Fonction pour placer les portails
func fire():
	if Input.is_action_just_pressed("Place_Portal"):
		#création d'une instance de la balle
		var bullet = bullet_path.instantiate()
		#Position de la balle
		bullet.global_position = $Weapon_rotation/Weapon/Shoot_Point.global_position
		#Rotation de la balle par rapport au joueur
		bullet.rotate($Weapon_rotation.rotation)
		#Ajout des clones des balles sur la scene
		get_tree().get_root().add_child(bullet)
		#Application d'une impulsion
		var impulse_direction = Vector2.RIGHT.rotated($Weapon_rotation.rotation)
		impulse_direction = impulse_direction.normalized()		
		bullet.apply_impulse(impulse_direction * 1000)
		
func camera_shake():
	var target_position = get_global_mouse_position()
	$Camera2D.global_position = $Player_Sprite.global_position + target_position / 40
		
#Système de gravité et déplacements basiques
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	fire() #Appel du check s'il y a eu un tir
	camera_shake() #Mouvements de la caméra
	move_and_slide()

#Timer ajouté pour ne pas pouvoir spam
func _on_timer_timeout():
	pass
