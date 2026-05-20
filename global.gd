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
	ITEMS.GUN,
	ITEMS.SHOTGUN,
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
	ROCKET_LAUNCHER,
	GUN,
	SHOTGUN,
	} #, RUBBER_BULLETS

var item_scenes := {
	ITEMS.AMOUNT_UP: preload("res://upgrades/amount_up.tscn"),
	ITEMS.BURST_UP: preload("res://upgrades/burst_up.tscn"),
	ITEMS.RICOCHET_UP: preload("res://upgrades/ricochet_up.tscn"),
	ITEMS.MOVESPEED_UP: preload("res://upgrades/movespeed_up.tscn"),
	ITEMS.MAX_HEALTH_UP: preload("res://upgrades/max_health_up.tscn"),
	ITEMS.REGEN_UP: preload("res://upgrades/regen_up.tscn"),
	ITEMS.JETPACK: preload("res://upgrades/jetpack_item.tscn"),
	ITEMS.ROCKET_LAUNCHER: preload("res://upgrades/rocket_launcher_item.tscn"),
	ITEMS.GUN: preload("res://upgrades/gun_item.tscn"),
	ITEMS.SHOTGUN: preload("res://upgrades/shotgun_item.tscn"),
	#ITEMS.ITEMNAME: preload(),
	#ITEMS.ITEMNAME: preload(),
	#ITEMS.ITEMNAME: preload(),
	#ITEMS.RUBBER_BULLETS: preload("res://upgrades/rubber_bullets.tscn"),
}

func get_available_items() -> Array:
	var result : Array = ITEMS.values()
	
	var player_item_nodes = player.find_child("SurvivorsUI").find_child("Items").get_children()
	
	#for item_node in player_item_nodes:
		#var item_id_and_copies : Array = []
		#item_id_and_copies.append(item_node.item_id)
		#item_id_and_copies.append(item_node.copies)
		#player_items.append(item_id_and_copies)
	
	var player_level_nines : Array = []
	
	var player_passives : int = 0
	var player_weapons : int = 0
	
	for item_node in player_item_nodes:
		var item_id = item_node.item_id
		var item_copies = item_node.copies
		
		
		
		if item_id in PASSIVES_POOL: player_passives += 1
		if item_id in WEAPONS_POOL: player_weapons += 1
		
		if player_weapons >= 6:
			for weapon in WEAPONS_POOL:
				if result.has(weapon):
					result.remove_at(result.find(weapon))
			#remove all weapons from result
		
		if player_passives >= 6:
			for passive in PASSIVES_POOL:
				if result.has(passive):
					result.remove_at(result.find(passive))
			#remove all passives from result
		
		if item_copies == 9: 
			#mark as ingredient ready
			player_level_nines.append(item_id)
			if result.has(item_id):
				result.remove_at(result.find(item_id))
	
	
	for evo in EVOLUTIONS_POOL:
		
		var player_has_evo := false
		
		for item_node in player_item_nodes:
			if item_node.item_id == evo:
				player_has_evo = true
				break
		
		if player_has_evo:
			result.remove_at(result.find(evo))
		
		elif player_level_nines.has(evolutions[evo]["weapon"]) \
		and player_level_nines.has(evolutions[evo]["passive"]):
			continue
		
		elif result.has(evo):
			result.remove_at(result.find(evo))
	
	#no more than 6 unique weapons and 6 unique passives. 
	#no item can be given more than 9 times. 
	#evolution of item can appear when evo. ingredient is at 9 copies 
	#when an evolution is taken, both ingredients are set to level 9 
	#evolutions can be given only once each.
	
	
	
	return result
