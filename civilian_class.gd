class_name Civilian
extends CharacterBody2D
var visible_on_screen : bool = true
var update_rate : float = 1.0

var has_projectile_impulse : bool = false

@export var responsiveness : float = 10.0
@export var always_sprinting : bool = false
@export var is_player : bool = false
var is_alive : bool = true

@export var weapon : Node
@export var controller : Node
@export var playercam : Node

@export var bouncy_projectiles : bool = false


@export var max_velocity := 300.0
@export var speed : float = 50.0
const SPRINT_MOD : float = 2.0

var burn_tick_delta : float = 0.0

var knockback_mod : float = 0.0
var ricochet_mod : int = 0
var burst_mod : int = 0
var amount_mod : int = 0
var spread_degrees_mod : float = 0.0
var accuracy_mod : float = 0.0 # weapon spread degrees *= 1 - accuracy_mod. range from 0 to 1
var damage_mod : float = 0.0 # as % increase
var area_mod : float = 0.0 # as % increase
var fire_rate_mod : float = 0.0 # as % reduction

var burn_damage : float = 0.2

var size_mod : float = 0.0 #as % increase to body "scale"

var max_hp = 3.0
var hp : float = 3.0
var regen : float = 0.1 #per second
var luck

var xp_reward : int = 1

var levelup_options : int = 3
var levelup_rerolls : int = 0

var elite : bool = false #triple HP, double size, half speed or something
var is_wave_elite : bool = false #ensures drop

func update_body_size():
	$Area2D/CollisionShape2D.scale *= 1.0 + size_mod
	$CollisionShape2D.scale *= 1.0 + size_mod
	$CivilianBody.scale *= 1.0 + size_mod
	default_shadow_scale *= 1.0 + size_mod
	$EntityShadow.position.y *= 1.0 + size_mod
	weapon_holding_radius *= 1.0 + size_mod

func give_item(item : Global.ITEMS):
	var item_instance = Global.item_scenes[item].instantiate()
	item_instance.item_id = item
	$SurvivorsUI/BaseLayer/Items.add_child(item_instance)
	item_instance.given_to_player()

func hit(dmg : float):
	#EffectManager.play_sound_effect("hit")
	EffectManager.spawn_blood_splat_particle_effect(global_position, randi_range(1,3))
	
	flash_color()
	
	hp -= dmg
	
	if hp <= 0.0 and is_alive:
		kill()

func update_player_hp():
	if !is_player:
		return
	
	#healthbar color logic etc
	$HealthBar.modulate = Color.RED
	
	$HealthBar.value = (hp / max_hp) * 100.0

var xp_orb_scene = preload("res://xp_orb_scene.tscn")

func award_xp(_xp_reward):
	$SurvivorsUI.change_xp(_xp_reward)

func kill():
	is_alive = false
	
	if randf_range(0.0,1.0) > 0.5:
		var xp_orb_instance = xp_orb_scene.instantiate()
		xp_orb_instance.value = xp_reward
		xp_orb_instance.global_position = global_position
		xp_orb_instance.team = Global.enemy_team
		get_tree().get_current_scene().find_child("GameObjects").call_deferred("add_child", xp_orb_instance) #spawn XP orb
	
	if elite:
		if is_wave_elite:
			drop_chest()
		elif randf() < 1.01:
			drop_chest()
	
	get_tree().get_first_node_in_group("Player").award_xp(xp_reward * 0.1) #to give 10% of XP to player on kill
	
	$CivilianBody.die()
	queue_free()

func drop_chest():
	print("WHABAM LOOT")
	var chest_instance = Global.weapon_crate_scene.instantiate()
	
	chest_instance.global_position = global_position
	
	get_tree().get_current_scene().spawn_object(chest_instance)

#func _draw() -> void:
	#if !is_player:
		#return
	#draw_line(weapon.position, aim_dir * 300.0, Color.RED)

var aim_deadzone : float = 0.1
var weapon_scale_flip_deadzone := 0.1

var weapon_holding_radius : float = 4.0

var recoil_offset := Vector2.ZERO
var aim_dir : Vector2 = Vector2.RIGHT
func add_weapon_holding_radius_recoil(recoil: float):
	aim_dir = controller.get_aim_direction()
	if aim_dir == Vector2.ZERO:
		return
	
	var dir = aim_dir.normalized()
	
	# small random spread
	var rand = Vector2(
		randf_range(-0.3, 0.3),
		randf_range(-0.3, 0.3)
	)
	
	# push backward + jitter
	recoil_offset += (-dir + rand) * recoil * 6.0
	


func attacks(_delta):
	if !visible_on_screen:
		return
	
	var raw_aim_dir = controller.get_aim_direction()
	
	if raw_aim_dir.length() > aim_deadzone:
		aim_dir = aim_dir.lerp(raw_aim_dir, _delta * 10.0)
		
		var base = aim_dir * weapon_holding_radius + Vector2.UP
		
		$AimTarget.position = base + recoil_offset
		$AimTarget.position.x *= 1.5
		$AimTarget.rotation = aim_dir.angle()
		
		if weapon == null:
			return
		
		weapon.position = $AimTarget.position + $CivilianBody.position
		weapon.rotation = $AimTarget.rotation
		
		#cosmetic, weapon scale flip to match facing direction
		if aim_dir.x > weapon_scale_flip_deadzone:
			weapon.scale.y = 1.0
		elif aim_dir.x < -weapon_scale_flip_deadzone:
			weapon.scale.y = -1.0
		
	if controller.is_shooting():
		weapon.try_fire()

var regen_interval : float = 0.0
func _physics_process(delta: float) -> void:
	if !is_alive or Global.paused:
		return
	
	if is_player:
		Global.player_position = global_position
		
		
		
		attacks(delta)
		
		
		regen_interval += delta
		if regen_interval >= 1.0:
			regenerate_hp()
			regen_interval = 0.0
			
	
	if burn_time > 0.0:
		$CivilianBody.burning = true
		burn_time -= delta
		burn_tick_delta += delta
		if burn_tick_delta > burn_tick_interval:
			burn_tick_delta = 0.0
			hit(given_burn_damage)
	else:
		$CivilianBody.burning = false
	
	if visible_on_screen:
		recoil_offset = recoil_offset.lerp(Vector2.ZERO, delta * 20.0)
	else:
		recoil_offset = Vector2.ZERO
	
	
	
	movement(delta)
	collisions(delta)
	velocity = velocity.limit_length(max_velocity)
	
	calculate_shadow()
	
	move_and_slide()
	
	for item in $CivilianBody.get_children():
		if item.is_in_group("ProcessItem"):
			item._item_process(delta)
	
	update_player_hp()

func regenerate_hp():
	if !is_player:
		return
	hp += regen

func movement(delta):
	if visible_on_screen:
		var input_dir = controller.get_movement_direction_as_vector()
		var target_velocity = input_dir * speed# * (SPRINT_MOD if (controller.is_sprinting() or always_sprinting) else 1.0)
		
		velocity = velocity.move_toward(target_velocity, speed * responsiveness * delta)
		
		$CivilianBody.animate(delta, velocity)
	else:
		var input_dir = controller.get_movement_direction_as_vector()
		velocity = input_dir * speed

func collisions(_delta):
	if !visible_on_screen:
		return
	
	
	var push : Vector2 = Vector2.ZERO
	var bodies = $Area2D.get_overlapping_bodies()
	var count : int = min(bodies.size(), 6)

	for i in count:
		var other = bodies[i]
		if other == self:
			continue
		
		if other.is_in_group("Pickup"):
			other.pickup()
		
		#spinning sawblade lol
		#if is_player:
			#if other.is_player == false:
				#other.kill()

		var dir : Vector2 = global_position - other.global_position
		var dist : float = dir.length()
		if dist == 0:
			continue

		var radius := 20.0 # match Area size
		var strength := 1.0 - (dist / radius)
		if strength > 0.0:
			push += (dir / dist) * strength
	
	push = push.limit_length(1.0)
	if push.length() < 0.05:
		push = Vector2.ZERO
	
	
	add_impulse(push * 10.0) #can this be smoother and something else somehow.....
	
	if push != Vector2.ZERO:
		velocity = lerp(velocity, velocity * (Vector2.ONE * 0.4 if !is_player else 0.85) / (1.0 + size_mod), _delta * 20.0)

func add_impulse(force: Vector2):
	if is_player:
		return
	velocity += force / (1.0 + size_mod)

var default_shadow_scale : Vector2 = Vector2(6.0,3.0)
var default_shadow_alpha : float = 0.4

func add_projectile_impulse(impulse: Vector2):
	
	if has_projectile_impulse:
		return
	
	has_projectile_impulse = true
	
	add_impulse(impulse)
	
	reset_projectile_impulse_next_frame()

func reset_projectile_impulse_next_frame():
	await get_tree().physics_frame
	has_projectile_impulse = false


func calculate_shadow():
	if !visible:
		return
	
	var hop_factor : float = clampf(-$CivilianBody.position.y / $CivilianBody.max_hop_anim_height, 0.0, 1.0)
	
	
	$EntityShadow.scale = lerp(default_shadow_scale, default_shadow_scale * 0.7, hop_factor)
	$EntityShadow.self_modulate.a = lerp(default_shadow_alpha, default_shadow_alpha * 0.7, hop_factor)

func flash_color(color_to_flash_to : Color = Color.RED):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", color_to_flash_to, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	return
	
	visible_on_screen = true
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	return
	visible_on_screen = false
	

func set_civilian_body_type(_type):
	match _type:
		Global.TEAM.NONE: $CivilianBody.type = $CivilianBody.CIVILIAN_TYPE.NONE
		Global.TEAM.AGENTS: $CivilianBody.type = $CivilianBody.CIVILIAN_TYPE.AGENT
		Global.TEAM.ALIENS: $CivilianBody.type = $CivilianBody.CIVILIAN_TYPE.GREEN_ALIEN

var burn_time : float = 0.0


#called once.
var burn_tick_interval : float = 0.5
var given_burn_damage : float = 0.0
func burn(time : float, _burn_dmg):
	burn_time += time
	given_burn_damage = _burn_dmg
	hit(_burn_dmg) #take one tick of burn damage
