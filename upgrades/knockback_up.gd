extends Item


func given_to_player():
	get_tree().get_first_node_in_group("Player").knockback_mod += 25.0
