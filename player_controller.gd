class_name PlayerController
extends Controller

func get_movement_direction_as_vector() -> Vector2:
	return Input.get_vector("ui_left","ui_right","ui_up","ui_down")

func is_sprinting():
	return Input.is_action_pressed("sprint")

func is_shooting() -> bool:
	return Input.is_action_pressed("shoot")

func get_aim_direction() -> Vector2:
	return (get_global_mouse_position() - get_parent().global_position).normalized()
