class_name PlayerController
extends Controller

func get_movement_direction_as_vector() -> Vector2:
	return Input.get_vector("ui_left","ui_right","ui_up","ui_down")

func is_sprinting():
	return Input.is_action_pressed("sprint")

func is_shooting() -> bool:
	return Input.is_action_pressed("shoot") if Settings.auto_aim == false else true


#could TECHNICALLY  make a thing where aim_dir doesnt stress so much if you're surrounded, settling for whatever because all targets are within small relative distance 
func get_aim_direction() -> Vector2:
	if Settings.auto_aim == false:
		return (get_global_mouse_position() - get_parent().global_position).normalized()
	
	var nearest : Node2D = null
	var nearest_distance : float = INF
	
	for target in get_tree().get_nodes_in_group("Targetable"):
		
		var distance : float = get_parent().global_position.distance_squared_to(target.global_position)
		
		if distance > max_targetable_distance * max_targetable_distance:
			continue
		
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = target
	
	if nearest:
		return (nearest.global_position - get_parent().global_position).normalized()
	
	return Vector2.RIGHT
