extends Projectile

func _physics_process(delta):
	position += direction * speed * delta
	distance_cull_check()


var last_hit

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
		
		body.hit(damage)
		body.add_impulse(direction * knockback)
		#pick a semi random opposite direction
		var angle_offset = randf_range(-PI/3, PI/3)
		direction = direction.rotated(angle_offset).normalized()
		rotation = direction.angle()
		
		
		if ricochets <= 0:
			queue_free()
		
		ricochets -= 1
		
		await get_tree().process_frame
		has_hit = false
