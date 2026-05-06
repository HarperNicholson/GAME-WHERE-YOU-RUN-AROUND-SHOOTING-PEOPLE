extends Node
var paused : bool = false
var levelup_options : int = 3
var levelup_rerolls : int = 0
var player : CharacterBody2D

enum ITEMS {AMOUNT_UP, BURST_UP, RICOCHET_UP} #, RUBBER_BULLETS

var item_scenes := {
	ITEMS.AMOUNT_UP: preload("res://upgrades/amount_up.tscn"),
	ITEMS.BURST_UP: preload("res://upgrades/burst_up.tscn"),
	ITEMS.RICOCHET_UP: preload("res://upgrades/ricochet_up.tscn"),
	#ITEMS.RUBBER_BULLETS: preload("res://upgrades/rubber_bullets.tscn"),
}
