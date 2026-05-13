extends Area2D

var value : float = 0.0

var team : int

#need a little wobble up and down while chillin

# green 9eff85

func _ready() -> void:
	match team:
		1: $BrainSprite.show()
		2: $OrbSprite.show()
#		3: #zombies rotten brain etc

var speed : float = 0.0

#this so fuckin ugly, clean up tomorrow
#tomorrow i say: this works
var dir_to_area
func _on_area_entered(area: Area2D) -> void:
	if area.name == "XPMagnet":
		set_deferred("monitoring", false)
		
		
		var dir = (global_position - area.global_position).normalized()
		
		EffectManager.play_sound_effect(EffectManager.SFX.CLICK, global_position)
		EffectManager.spawn_xp_sparkle(global_position, dir.angle(), randi_range(2,4), Color.RED if team == 1 else Color.WHITE)
		#tiny sparkle of XP/blood
		
		var velocity = dir * 400.0
		
		var t := 0.0
		
		while true:
			var delta = get_physics_process_delta_time()
			t += delta
			
			
			
			var speed_factor = clamp(speed / 400.0, 0.0, 1.0)
			
			scale = Vector2(
				lerp(1.0, 2.0, speed_factor),
				lerp(1.0, 0.5, speed_factor)
			)
			
			if t < 0.25:
				global_position += velocity * delta
				velocity = velocity.move_toward(Vector2.ZERO, 2200.0 * delta)
				
				speed = velocity.length()
				
				if speed > 1.0:
					rotation = velocity.angle()
				
			else:
				speed += 1600 * delta
				speed = min(speed, 1600.0)
				
				dir_to_area = (area.global_position - global_position).normalized()
				global_position += dir_to_area * speed * delta
				
				rotation = dir_to_area.angle()
			if global_position.distance_to(area.global_position) < 8.0:
				break
			
			await get_tree().physics_frame
		
		var finaldir = (global_position - area.global_position).normalized()
		var twe : Tween = get_tree().create_tween().set_parallel()
		twe.tween_property(self, "scale", Vector2.ZERO, 0.03)
		twe.tween_property(self, "global_position", area.global_position, 0.03)
		await twe.finished
		EffectManager.spawn_xp_sparkle(global_position, finaldir.angle(), 12, Color.RED if team == 1 else Color.WHITE)
		EffectManager.play_sound_effect(EffectManager.SFX.BRAIN if team == 1 else EffectManager.SFX.XPORB, global_position)
		area.get_parent().award_xp(value)
		queue_free()
