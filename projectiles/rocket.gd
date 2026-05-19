extends Projectile


var elapsed : float = 0.0

var explosion_scene = preload("res://projectiles/explosion.tscn")


func _physics_process(delta):
	if has_hit:
		return
	elapsed += delta
	position += direction * speed * delta * elapsed
	distance_cull_check()


func _on_body_entered(body):
	if has_hit:
		return
	if body == shooter:
		return
	if body is Civilian:
		if body == last_hit:
			return
		last_hit = body
		has_hit = true
		
		call_deferred("explode")
		#pick a semi random opposite direction
		var angle_offset = randf_range(-PI/3, PI/3)
		direction = direction.rotated(angle_offset).normalized()
		rotation = direction.angle()
		
		
		if ricochets <= 0:
			queue_free()
		
		ricochets -= 1
		
		await get_tree().process_frame
		has_hit = false

func explode():
	has_hit = true
	$CPUParticles2D.emitting = false
	
	
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.damage_mod_from_owner = _owner.damage_mod
	explosion.burn_damage = _owner.burn_damage
	explosion.damage = damage * (1 + _owner.damage_mod)
	explosion.radius = 20.0 * (1 + _owner.area_mod) #placeholder, could be set by player's radius mod
	explosion.knockback = knockback
	explosion.shooter = shooter
	get_tree().current_scene.add_child(explosion)
