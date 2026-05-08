extends Item

func given_to_player():
	get_tree().get_first_node_in_group("Player").regen += 0.1
