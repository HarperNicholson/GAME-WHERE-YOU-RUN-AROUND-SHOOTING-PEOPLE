extends Node2D

enum MENU_SPOT { LEFT, CENTER, RIGHT }

func _on_aliens_team_button_pressed() -> void:
	set_gui_node_inputs_disabled()
	move_menu(MENU_SPOT.LEFT)
	Global.enemy_team = Global.TEAM.AGENTS


func _on_agents_team_button_pressed() -> void:
	set_gui_node_inputs_disabled()
	move_menu(MENU_SPOT.RIGHT)
	Global.enemy_team = Global.TEAM.ALIENS

func set_gui_node_inputs_disabled(_disabled := true):
	for node in get_tree().get_nodes_in_group("disableable"):
		print(node)
		node.disabled = _disabled

func move_menu(spot : MENU_SPOT = MENU_SPOT.CENTER):
	#tween the menu position to a spot, revealing the class selector etc for the appropriate team.
	#on finished, re-enable gui nodes
	pass
