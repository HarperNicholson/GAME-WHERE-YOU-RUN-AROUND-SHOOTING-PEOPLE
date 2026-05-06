extends Projectile


var elapsed : float = 0.0

var explosion_scene = preload("res://projectiles/explosion.tscn")


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
	call_deferred("explode")

func explode():
	has_hit = true
	$Sprite2D.hide()
	$CPUParticles2D.emitting = false
	
	
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.damage = damage
	explosion.radius = 20.0 #placeholder, could be set by player's radius mod
	explosion.knockback = knockback
	get_tree().current_scene.add_child(explosion)
	
	await get_tree().create_timer($CPUParticles2D.lifetime).timeout
	queue_free()
