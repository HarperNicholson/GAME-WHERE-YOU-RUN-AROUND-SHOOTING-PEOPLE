extends Item

func given_to_player():
	get_tree().get_first_node_in_group("Player").amount_mod += 1
	get_tree().get_first_node_in_group("Player").spread_degrees_mod += 3
