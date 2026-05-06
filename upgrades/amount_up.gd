extends Item

func given_to_player():
	get_tree().get_first_node_in_group("Player").weapon.amount_of_projectiles += 1
	get_tree().get_first_node_in_group("Player").weapon.spread_degrees += 1
