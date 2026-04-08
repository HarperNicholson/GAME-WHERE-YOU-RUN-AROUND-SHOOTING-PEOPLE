#class_name Gun ??
extends Node2D


@export var burst_count := 1
@export var burst_delay := 0.05
@export var recoil := 0.33
@export var projectile_scene : PackedScene
@export var fire_rate : float = 0.5
@export var spread_degrees : float = 3.0
@export var amount_of_projectiles : int = 1
@export var SFX : EffectManager.SFX = EffectManager.SFX.GUN


var cooldown := 0.0

func _process(delta):
	cooldown -= delta

func try_fire():
	if cooldown > 0:
		return
	
	cooldown = fire_rate
	fire()

func fire():
	var spread = deg_to_rad(spread_degrees)
	
	for b in range(burst_count):
		
		for i in range(amount_of_projectiles):
			var bullet = projectile_scene.instantiate()
			get_tree().current_scene.add_child(bullet)
			
			var dir = Vector2.RIGHT.rotated(global_rotation + randf_range(-spread, spread))
			
			bullet.global_position = global_position
			bullet.direction = dir
			bullet.rotation = dir.angle()
			bullet.shooter = get_parent()
		
		apply_recoil()
		EffectManager.play_sound_effect(SFX, global_position)
		
		if b < burst_count - 1:
			await get_tree().create_timer(burst_delay).timeout

func apply_recoil():
	if recoil == 0.0:
		return
	
	if owner.is_player:
		owner.playercam.add_trauma(recoil)
	
	if "velocity" in owner:
		owner.add_impulse(Vector2.LEFT.rotated(global_rotation) * recoil * 100.0)
