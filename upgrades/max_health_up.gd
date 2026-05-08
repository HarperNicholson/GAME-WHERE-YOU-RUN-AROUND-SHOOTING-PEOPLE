extends Item

func given_to_player():
	get_tree().get_first_node_in_group("Player").max_hp *= 1.1 #gain 10% max health
