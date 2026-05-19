extends Node

var weapon_crate_scene : PackedScene = preload("res://weapon_crate.tscn")


var paused : bool = false
var levelup_options : int = 3
var levelup_rerolls : int = 0
var player : CharacterBody2D
var player_position : Vector2 = Vector2.ZERO

var difficulty : float = 0.0

var enemy_team : TEAM = TEAM.AGENTS

enum TEAM { NONE, AGENTS, ALIENS}

var evolutions := {
	ITEMS.JETPACK: {
		"weapon": ITEMS.ROCKET_LAUNCHER,
		"passive": ITEMS.MOVESPEED_UP,
	},
}

var WEAPONS_POOL := [
	ITEMS.ROCKET_LAUNCHER,
]

var PASSIVES_POOL := [
	ITEMS.MOVESPEED_UP,
	ITEMS.MAX_HEALTH_UP,
	ITEMS.REGEN_UP,
	ITEMS.AMOUNT_UP,
	ITEMS.BURST_UP,
	ITEMS.RICOCHET_UP,
]

var EVOLUTIONS_POOL := [
	ITEMS.JETPACK,
]

enum ITEMS {
	AMOUNT_UP, 
	BURST_UP, 
	RICOCHET_UP, 
	MOVESPEED_UP,
	MAX_HEALTH_UP,
	REGEN_UP,
	JETPACK,
	ROCKET_LAUNCHER
	} #, RUBBER_BULLETS

var item_scenes := {
	ITEMS.AMOUNT_UP: preload("res://upgrades/amount_up.tscn"),
	ITEMS.BURST_UP: preload("res://upgrades/burst_up.tscn"),
	ITEMS.RICOCHET_UP: preload("res://upgrades/ricochet_up.tscn"),
	ITEMS.MOVESPEED_UP: preload("res://upgrades/movespeed_up.tscn"),
	ITEMS.MAX_HEALTH_UP: preload("res://upgrades/max_health_up.tscn"),
	ITEMS.REGEN_UP: preload("res://upgrades/regen_up.tscn"),
	ITEMS.JETPACK: preload("res://upgrades/jetpack_icon.tscn"),
	#ITEMS.ITEMNAME: preload(),
	#ITEMS.RUBBER_BULLETS: preload("res://upgrades/rubber_bullets.tscn"),
}

func get_available_items() -> Array[ITEMS]:
	var result : Array[ITEMS] = ITEMS.values()
	
	var player_items = player.find_child("SurvivorsUI").find_child("Items").get_children()
	
	for item in player_items:
		var item_id = item.item_id #this will return ITEMS.ITEM_NAME
		var item_copies = item.copies #this will return an int >= 1
		
		#tally up item types first, then start removing conditional
		
		#if > 6 weapons:
		#remove all weapons
		
		#same goes for passives, if >6 passives remove all passives
		
		if item.copies == 9:
			if result.has(item_id):
				result.remove_at(result.find(item_id))
		
	
	#no more than 6 unique weapons and 6 unique passives. 
	#no item can be given more than 9 times. 
	#evolutions can appear when an evolution ingredient is at copy level 9. 
	#when an evolution is taken, both ingredients are set to level 9 
	#evolutions can be given only once each.
	#levelup options must be unique. if only one option is available, only one will show.
	
	
	return result
