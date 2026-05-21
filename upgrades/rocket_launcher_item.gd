extends Item

func given_to_player():
	match copies:
		1: pass # unique stats for each levelup
	
	print("ROCKET LEVEL " + str(copies))
	
	var player = get_tree().get_first_node_in_group("Player")
	
	for item in player.get_children():
		if item.name == "RocketLauncher":
			print("RETURNING")
			return
	
	var weapon_instance = load("res://weapons/rocket_launcher.tscn").instantiate()
	weapon_instance.weapon_id = item_id
	player.add_child(weapon_instance)
	
	if player.weapon == null:
		player.weapon = weapon_instance
	
