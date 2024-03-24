extends CharacterBody2D

#Config du player
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var portal_status = {
	"last_portal": "None",
	"portal_count": 0
}

@onready var sprite_2d = $Player_Sprite

var blue = false
var orange = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var weapon_sprite = $Weapon_rotation/Weapon
var isLeft = velocity.x < 0

#assets dont j'ai besoin pour l'arme
const bullet_path = preload("res://scenes/bullet.tscn")

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
		# Création & destruction des murs (mécanique de portal)
		if portal_status["last_portal"] == "None":
			bullet.blue = true
			bullet.orange = false
			portal_status["last_portal"] = "Blue"
		elif portal_status["last_portal"] == "Blue":
			for wall in bullet.created_walls_o:
					wall.queue_free()
			bullet.created_walls_o.clear()
			bullet.blue = false
			bullet.orange = true
			portal_status["last_portal"] = "Orange"
		elif portal_status["last_portal"] == "Orange":
			for wall in bullet.created_walls_b:
					wall.queue_free()
			bullet.created_walls_b.clear()
			bullet.blue = true
			bullet.orange = false
			portal_status["last_portal"] = "Blue"

#Effet de camera pour ajouter de la vie au gameplay
func camera_shake():
	var target_position = get_global_mouse_position()
	$Camera2D.global_position = $Player_Sprite.global_position + target_position / 40

#Au cas où le joueur tombe	
func check_fall():
	#print($Player_Sprite.global_position.x)
	if $Player_Sprite.global_position.y > 1000:
		var player = get_node("../player")
		player.global_position = get_node("../Spawn").global_position

#Changer la couleur du pistolet par rapport à la couleur du portail à placer
func change_weapon_color():
	$Weapon_rotation/Weapon/PointLight2D.energy = 0.01
	if portal_status["last_portal"] == "None":
		$Weapon_rotation/Weapon/PointLight2D.color = Color(0, 0, 255)
		$Weapon_rotation/Weapon.texture = load("res://assets/pistol_blue.png")
	elif  portal_status["last_portal"] == "Blue":
		$Weapon_rotation/Weapon/PointLight2D.color = Color(255, 188, 0)
		$Weapon_rotation/Weapon.texture = load("res://assets/pistol_orange.png")
	elif portal_status["last_portal"] == "Orange":
		$Weapon_rotation/Weapon/PointLight2D.color = Color(0, 0, 255)
		$Weapon_rotation/Weapon.texture = load("res://assets/pistol_blue.png")

#Système de gravité et déplacements basiques
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if Global.gravity == 0:
			velocity.y += gravity * delta
	if not is_on_ceiling():
		if Global.gravity == 1:
			velocity.y -= gravity * delta
	if not is_on_wall():
		if Global.gravity == 2:
			velocity.x += gravity * delta
		if Global.gravity == 3:
			velocity.x -= gravity * delta
	else:
		Global.take_portal = false

	# Handle jump.
	if Input.is_action_just_pressed("Jump"):
		if (is_on_floor()):
			if Global.gravity == 0:
				velocity.y = JUMP_VELOCITY
		if (is_on_ceiling()):
			if Global.gravity == 1:
				velocity.y = -JUMP_VELOCITY
		if (is_on_wall()):
			if Global.gravity == 2:
				velocity.x = JUMP_VELOCITY
			if Global.gravity == 3:
				velocity.x = -JUMP_VELOCITY

	var direction = Input.get_axis("Left", "Right")
	if direction:
		if Global.gravity == 0:
			if velocity.x > direction * SPEED && Global.take_portal == true:
				velocity.x -= 10
			elif velocity.x < direction * SPEED && Global.take_portal == true:
				velocity.x += 10
			else:
				velocity.x = direction * SPEED
		if Global.gravity == 1:
			if velocity.x > -direction * SPEED && Global.take_portal == true:
				velocity.x -= 10
			elif velocity.x < -direction * SPEED && Global.take_portal == true:
				velocity.x += 10
			else:
				velocity.x = -direction * SPEED
		if Global.gravity == 2:
			if velocity.y > direction * SPEED && Global.take_portal == true:
				velocity.y -= 10
			elif velocity.y < direction * SPEED && Global.take_portal == true:
				velocity.y += 10
			else:
				velocity.y = -direction * SPEED
		if Global.gravity == 3:
			if velocity.y > direction * SPEED && Global.take_portal == true:
				velocity.y -= 10
			elif velocity.y < direction * SPEED && Global.take_portal == true:
				velocity.y += 10
			else:
				velocity.y = direction * SPEED
	else:
		if Global.take_portal == true:
			pass
		else:
			if Global.gravity == 0 || Global.gravity == 1:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			if Global.gravity == 2 || Global.gravity == 3:
				velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
	#Retourne l'arme pour qu'il vise toujours bien
	weapon_sprite.flip_h = isLeft # NON FONCTIONNEL
	
	check_fall() #Check si le joueur est tombé dans le "void"
	change_weapon_color() #Changer la couleur de l'arme
	fire() #Appel du check s'il y a eu un tir
	camera_shake() #Mouvements de la caméra
	move_and_slide()

#Timer ajouté pour ne pas pouvoir spam
func _on_timer_timeout():
		pass

