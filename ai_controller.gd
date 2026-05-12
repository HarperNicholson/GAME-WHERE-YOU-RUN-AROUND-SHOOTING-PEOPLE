class_name AIController
extends Controller

func get_movement_direction_as_vector() -> Vector2:
	return (Global.player_position - owner.global_position).normalized()

func is_shooting() -> bool:
	return randf() < 0.01

func is_sprinting():
	return false
