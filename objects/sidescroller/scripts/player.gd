extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() && not is_on_ceiling() && not is_on_wall():
		if Global.gravity == 0:
			velocity.y += gravity * delta
		if Global.gravity == 1:
			velocity.y -= gravity * delta
		if Global.gravity == 2:
			velocity.x += gravity * delta
		if Global.gravity == 3:
			velocity.x -= gravity * delta
	else:
		Global.take_portal = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if (is_on_floor() || is_on_ceiling() || is_on_wall()):
			if Global.gravity == 0:
				velocity.y = -JUMP_VELOCITY
			if Global.gravity == 1:
				velocity.y = JUMP_VELOCITY
			if Global.gravity == 2:
				velocity.x = -JUMP_VELOCITY
			if Global.gravity == 3:
				velocity.x = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
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

