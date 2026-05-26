extends Node
class_name Item

var copies : int = 1

var item_id

var theme = preload("res://new_theme.tres")
func _ready() -> void:
	apply_theme_recursive(self)

func apply_theme_recursive(node: Node) -> void:
	if node is Control:
		node.theme = theme
	
	for child in node.get_children():
		apply_theme_recursive(child)

func given_to_player():
	pass

func _item_process(_delta):
	pass
