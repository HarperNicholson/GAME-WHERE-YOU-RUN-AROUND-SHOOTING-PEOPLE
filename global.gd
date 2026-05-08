extends Node

var paused : bool = false
var levelup_options : int = 3
var levelup_rerolls : int = 0
var player : CharacterBody2D

enum ITEMS {
	AMOUNT_UP, 
	BURST_UP, 
	RICOCHET_UP, 
	MOVESPEED_UP,
	MAX_HEALTH_UP,
	REGEN_UP,
	
	} #, RUBBER_BULLETS

var item_scenes := {
	ITEMS.AMOUNT_UP: preload("res://upgrades/amount_up.tscn"),
	ITEMS.BURST_UP: preload("res://upgrades/burst_up.tscn"),
	ITEMS.RICOCHET_UP: preload("res://upgrades/ricochet_up.tscn"),
	ITEMS.MOVESPEED_UP: preload("res://upgrades/movespeed_up.tscn"),
	ITEMS.MAX_HEALTH_UP: preload("res://upgrades/max_health_up.tscn"),
	ITEMS.REGEN_UP: preload("res://upgrades/regen_up.tscn"),
	#ITEMS.ITEMNAME: preload(),
	#ITEMS.RUBBER_BULLETS: preload("res://upgrades/rubber_bullets.tscn"),
}
