extends Node2D

@export var line_color : Color
@export var line_width : float = 0.5

@export var start_node: Node2D
@export var end_node: Node2D


func _draw() -> void:
	if start_node == null or end_node == null:
		return
	draw_line(to_local(start_node.global_position),to_local(end_node.global_position),line_color,line_width)
