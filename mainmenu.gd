extends Node2D

enum MENU_SPOT { LEFT, CENTER, RIGHT }

func _physics_process(delta: float) -> void:
	$Control/CivilianBody.animate(delta, Vector2.ZERO)
	$Control/CivilianBody2.animate(delta, Vector2.ZERO)

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
	
	var target_position_x : float
	
	match spot:
		MENU_SPOT.LEFT: target_position_x = -360.0
		MENU_SPOT.CENTER: target_position_x = 0.0
		MENU_SPOT.RIGHT: target_position_x = 360.0
	
	var menu_tween : Tween = get_tree().create_tween()
	
	menu_tween.tween_property($Control, "position:x", target_position_x, 1.0)
	#tween the menu position to a spot, revealing the class selector etc for the appropriate team.
	
	await menu_tween.finished
	set_gui_node_inputs_disabled(false)
	#on finished, re-enable gui nodes
