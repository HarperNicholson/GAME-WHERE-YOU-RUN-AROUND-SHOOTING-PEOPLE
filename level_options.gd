extends CanvasLayer

var levelups : int = 0
var options : Array = []

func refresh():
	options.clear()
	
	for old in $LevelUpOptions.get_children():
		old.queue_free()
	
	for child in $LevelUpButtons.get_children():
		child.hide()
	
	
	
	
	
	
	var available_items = Global.get_available_items()
	available_items.shuffle()
	
	for i in range(min(Global.levelup_options, available_items.size())):
		var item = available_items[i]
		
		options.append(item)
		
		var scene = Global.item_scenes[item]
		var option = scene.instantiate()
		
		$LevelUpButtons.get_child(i).show()
		
		$LevelUpOptions.add_child(option)
	
	
	
	
	
	$"LevelUpButtons/Control/0".grab_focus()

func selected(button):

	get_tree().get_first_node_in_group("Player").give_item(options[int(button.name)])

	levelups -= 1

	if levelups <= 0:
		Global.paused = false
		hide()

	refresh()
