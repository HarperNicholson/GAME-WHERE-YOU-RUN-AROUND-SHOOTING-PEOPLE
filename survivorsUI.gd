extends Control

var player_xp : float = 0.0

var xp_required : float = 5.0

var level : int = 1


func change_xp(amount):
	player_xp += amount
	
	if player_xp >= xp_required:
		player_xp -= xp_required
		level_up()
	
	#$XPMeter ranges from 0.0 - 100.0
	
	var percent = player_xp / xp_required
	$XPMeter.value = percent * 100.0

func level_up():
	level += 1
	$LevelUpLayer.levelups += 1
	$LevelUpLayer.show()
	$LevelLabel.text = "Level " + str(level)
	xp_required *= 1.2
	Global.paused = true
