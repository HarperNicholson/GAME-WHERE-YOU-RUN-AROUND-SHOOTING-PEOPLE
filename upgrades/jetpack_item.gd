extends Item

#you can get jetpack after 10 speed ups
#because 50 + 150 = 200

func given_to_player():
	get_tree().get_first_node_in_group("Player").speed += 15.0 #should be 200.0 as jetpack acts as final movespeed up
	
	#give player jetpack physical item
	get_tree().get_first_node_in_group("Player").find_child("CivilianBody").add_child(load("res://evolutions/jetpack.tscn").instantiate())
