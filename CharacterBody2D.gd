extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Fonction pour le viseur de l'arme
func _process(delta):
	var target_position = get_global_mouse_position()
	#Regard sur la souris → Il est basé sur le centre du joueur
	$Weapon.look_at(target_position)

#Fonction pour placer les portails
func fire():
	if Input.is_action_just_pressed("Place_Portal"):
		print("fire")

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
	move_and_slide()
