class_name AIController
extends Controller

func get_movement_direction_as_vector() -> Vector2:
	return Vector2.ZERO

func is_shooting() -> bool:
	return randf() < 0.01

func is_sprinting():
	return false
