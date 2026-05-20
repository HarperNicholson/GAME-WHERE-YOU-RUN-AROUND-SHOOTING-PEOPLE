extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item_name in Global.ITEMS.keys():
		$Panel/OptionButton.add_item(item_name)

func _on_give_button_pressed() -> void:
	var selected_name = $Panel/OptionButton.get_item_text(
		$Panel/OptionButton.selected
	)
	
	Global.player.give_item(Global.ITEMS[selected_name])


func _on_xp_slider_value_changed(value: float) -> void:
	$Panel/AddXPButton.text = "add " + str(value) + " XP"


func _on_add_xp_button_pressed() -> void:
	Global.player.award_xp($Panel/XPSlider.value)


func _on_level_up_button_pressed() -> void:
	Global.player.find_child("SurvivorsUI").level_up()
