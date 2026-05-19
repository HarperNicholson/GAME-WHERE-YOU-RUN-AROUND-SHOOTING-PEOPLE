extends Area2D

var damage_mod_from_owner : float = 0.0
var burn_damage : float = 0.0
var damage : float = 0.0
var radius : float = 0.0
var knockback : float = 0.0

var shooter

func _ready():
	await get_tree().physics_frame
	EffectManager.spawn_explosion_particle_effect(global_position)
	EffectManager.spawn_explosion_flat_decal(global_position)
	EffectManager.play_sound_effect(EffectManager.SFX.EXPLOSION, global_position)
	
	$CollisionShape2D.shape.radius = radius
	
	for body in get_overlapping_bodies():
		var dist = global_position.distance_to(body.global_position)
		var t = clamp(dist / radius, 0.0, 1.0)
		
		var distance_from_center_factor = lerp(1.0, 0.1, t)
		
		if body is Civilian and body != shooter:
			var dir = (body.global_position - global_position).normalized()
			
			body.hit(damage * 2.0 * distance_from_center_factor)
			
			if randf() < 0.1:
				body.burn(2.5, burn_damage * (1.0 + damage_mod_from_owner))
			
			if not body.has_projectile_impulse:
				body.add_projectile_impulse(dir * knockback * distance_from_center_factor)
	
	queue_free()
