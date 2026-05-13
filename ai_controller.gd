class_name AIController
extends Controller

func get_movement_direction_as_vector() -> Vector2:
	var to_player : Vector2 = Global.player_position - owner.global_position
	
	var dist_sq : float = to_player.length_squared()
	
	if dist_sq <= 0.001:
		return Vector2.ZERO
	
	var dir : Vector2 = to_player.normalized()
	
	#orbit very near player
	if dist_sq < (8.0 * 8.0):
		var orbit_dir : Vector2 = dir.orthogonal()
		
		#split orbit directions
		if owner.get_instance_id() % 2 == 0:
			orbit_dir *= -1.0
		
		dir = dir.lerp(orbit_dir, 0.9).normalized()
	
	return dir

func is_shooting() -> bool:
	return randf() < 0.01

func is_sprinting():
	return false
