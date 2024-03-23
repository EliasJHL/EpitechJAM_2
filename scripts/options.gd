extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")


func _on_left_config_pressed():
	# Afficher un message pour indiquer à l'utilisateur qu'il peut maintenant entrer la nouvelle touche
	print("Cliquez sur une touche pour changer le keybind...")

	# Attendre que l'utilisateur appuie sur une touche
	var old_keybind = InputMap.action_get_events("Left") # Récupère le premier keybind de l'action

	# Effacer l'ancien keybind pour éviter les doublons
	InputMap.erase_action("Left")
	await InputEventKey # Attend un nouvel événement d'entrée

	var key = InputEventKey
	print(key)
	# Mettre à jour le keybind avec la nouvelle touche choisie par l'utilisateur
	#var new_key = get_tree().input.get_action_strength(get_name()) > 0
	#InputMap.add_action("Left", new_key)
	#print("Nouveau keybind pour", get_name(), ":", new_key)
