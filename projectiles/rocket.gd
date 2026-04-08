extends Projectile


var elapsed : float = 0.0

func _physics_process(delta):
	if has_hit:
		return
	elapsed += delta
	position += direction * (speed / 2) * delta * elapsed
	distance_cull_check()

func _on_body_entered(body):
	if has_hit:
		return
	if body == shooter:
		return
	explode()

func explode():
	#spawn particle
	has_hit = true
	$Sprite2D.hide()
	$CPUParticles2D.emitting = false
	await get_tree().create_timer($CPUParticles2D.lifetime).timeout
	queue_free()
