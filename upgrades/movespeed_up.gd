extends Item

func given_to_player():
	if copies <= 10:
		Global.player.speed += 15.0
