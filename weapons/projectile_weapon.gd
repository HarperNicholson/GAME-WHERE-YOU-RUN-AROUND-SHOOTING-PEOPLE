#class_name Gun ??
extends Node2D


@export var burst_count := 1
@export var burst_delay := 0.15
@export var recoil := 0.33
@export var projectile_scene : PackedScene
@export var fire_rate : float = 0.5
@export var spread_degrees : float = 3.0
@export var amount_of_projectiles : int = 1
@export var projectile_ricochets : int = 0
@export var projectile_damage : float = 1.0
@export var projectile_knockback : float = 50.0
@export var SFX : EffectManager.SFX = EffectManager.SFX.GUN

var cooldown := 0.0

func _process(delta):
	cooldown -= delta

func try_fire():
	if cooldown > 0:
		return
	
	cooldown = fire_rate * (1 - owner.fire_rate_mod)
	fire()

func fire():
	var spread = (deg_to_rad(spread_degrees) + deg_to_rad(owner.spread_degrees_mod)) * (1 - owner.accuracy_mod)
	
	for b in range(burst_count + owner.burst_mod):
		for i in range(amount_of_projectiles + owner.amount_mod):
			var projectile_instance = projectile_scene.instantiate()
			get_tree().current_scene.add_child(projectile_instance)
			
			var dir = Vector2.RIGHT.rotated(global_rotation + randf_range(-spread, spread))
			
			projectile_instance.ricochets = projectile_ricochets + owner.ricochet_mod
			projectile_instance.damage = projectile_damage * (1 + owner.damage_mod)
			projectile_instance.knockback = projectile_knockback + owner.knockback_mod
			projectile_instance.area_mod = owner.area_mod
			projectile_instance.bouncy = owner.bouncy_projectiles
			
			projectile_instance.global_position = $ProjectileSpawn.global_position
			projectile_instance.direction = dir
			projectile_instance.rotation = dir.angle()
			projectile_instance.shooter = get_parent()
		
		apply_recoil()
		EffectManager.play_sound_effect(SFX, global_position)
		
		if b < (burst_count + owner.burst_mod) - 1:
			await get_tree().create_timer(burst_delay).timeout

func apply_recoil():
	if recoil == 0.0:
		return
	
	if owner.is_player:
		owner.playercam.add_trauma(recoil)
	
	if "velocity" in owner:
		owner.add_impulse(Vector2.LEFT.rotated(global_rotation) * recoil * 100.0)
	
	owner.add_weapon_holding_radius_recoil(recoil)
