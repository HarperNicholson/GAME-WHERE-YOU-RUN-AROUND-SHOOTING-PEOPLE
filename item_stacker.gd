extends GridContainer

func _on_child_entered_tree(node: Node) -> void:
	for child in get_children():
		if node != child:
			if node.item_id == child.item_id:
				node.hide()
				child.copies += 1
				child.find_child("Label").text = "x" + str(child.copies)
				_sort_children()
				break

func _sort_children():
	var children = get_children()
	children.sort_custom(func(a, b):
		return a.copies > b.copies
	)
	
	for i in children.size():
		move_child(children[i], i)
