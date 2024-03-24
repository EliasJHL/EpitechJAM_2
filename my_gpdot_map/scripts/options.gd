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
	pass
	#var old_keybind = InputMap.action_get_events("Left") # Récupère le premier keybind de l'action

	#InputMap.erase_action("Left")
	#await InputEventKey

	#var key = InputEventKey
	#print(key)
	#var new_key = get_tree().input.get_action_strength(get_name()) > 0
	#InputMap.add_action("Left", new_key)
	
