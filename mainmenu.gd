extends Node2D

enum MENU_SPOT { LEFT, CENTER, RIGHT }

func _on_aliens_team_button_pressed() -> void:
	$Control/AgentsTeamButton.disabled = true
	move_menu(MENU_SPOT.LEFT)
	pass # Replace with function body.


func _on_agents_team_button_pressed() -> void:
	$Control/AgentsTeamButton.disabled = true
	move_menu(MENU_SPOT.RIGHT)

func move_menu(spot : MENU_SPOT = MENU_SPOT.CENTER):
	#tween the menu position to a spot, revealing the class selector etc for the appropriate team.
	pass
