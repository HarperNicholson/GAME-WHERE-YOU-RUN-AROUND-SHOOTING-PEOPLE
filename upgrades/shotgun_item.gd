extends Item

func given_to_player():
	var player = get_tree().get_first_node_in_group("Player")
	var weapon_instance = load("res://weapons/shotgun.tscn").instantiate()
	player.add_child(weapon_instance)
	if player.weapon == null: player.weapon = weapon_instance
