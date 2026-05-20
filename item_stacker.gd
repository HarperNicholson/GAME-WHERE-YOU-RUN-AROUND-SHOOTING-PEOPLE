extends GridContainer


func _sort_children():
	var children = get_children()
	children.sort_custom(func(a, b):
		return a.copies > b.copies
	)
	
	for child in children:
		child.find_child("Label").text = "x" + str(child.copies)
	
	for i in children.size():
		move_child(children[i], i)
