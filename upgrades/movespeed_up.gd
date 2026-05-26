extends Item

func given_to_player():
	if copies <= 9:
		Global.player.speed += 17.0
