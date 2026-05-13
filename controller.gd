class_name Controller
extends Node2D

var max_targetable_distance : float = 140.0

func get_movement_direction_as_vector() -> Vector2:
	return Vector2.ZERO

func is_shooting() -> bool:
	return false
