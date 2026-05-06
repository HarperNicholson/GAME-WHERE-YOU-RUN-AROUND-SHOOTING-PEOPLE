extends Area2D

var damage : float = 0.0
var radius : float = 0.0
var knockback : float = 0.0

func _ready():
	await get_tree().physics_frame
	EffectManager.spawn_explosion_particle_effect(global_position)
	EffectManager.play_sound_effect(EffectManager.SFX.EXPLOSION, global_position)
	
	$CollisionShape2D.shape.radius = radius
	
	for body in get_overlapping_bodies():
		var dist = global_position.distance_to(body.global_position)
		var t = clamp(dist / radius, 0.0, 1.0)
		
		var distance_from_center_factor = lerp(1.0, 0.1, t)
		
		if body is Civilian:
			var dir = (body.global_position - global_position).normalized()
			
			body.hit(damage * 2.0 * distance_from_center_factor)
			body.add_impulse(dir * knockback * distance_from_center_factor)
	
	queue_free()
