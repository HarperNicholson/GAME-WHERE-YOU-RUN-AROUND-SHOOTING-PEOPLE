extends Projectile


func _physics_process(delta):
	position += direction * speed * delta
	distance_cull_check()

func _on_body_entered(body):
	if has_hit:
		return
	if body == shooter:
		return
	if body is Civilian:
		has_hit = true
		body.hit()
		body.add_impulse(direction * knockback)
		queue_free()
