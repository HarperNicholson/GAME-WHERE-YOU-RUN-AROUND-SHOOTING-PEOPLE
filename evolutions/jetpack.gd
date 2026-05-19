extends Item

var burn_damage

var try_burn_interval : float = 0.0

#burn and push back in an area around the player
func _item_process(_delta):
	try_burn_interval += _delta
	
	if try_burn_interval >= 0.1:
		try_burn_interval = 0.0
		burn_in_radius()

func burn_in_radius():
	var burn_radius : float = 20.0 #factor area mod
	
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.global_position.distance_to(Global.player_position) < burn_radius:
			enemy.burn(5.0, get_parent().owner.burn_damage * (1.0 + get_parent().owner.damage_mod))
